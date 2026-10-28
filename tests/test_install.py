"""Exercise the installer against disposable homes, never the real config."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]
LINKS = {
    '.zshrc': 'zsh/.zshrc',
    '.zprofile': 'zsh/.zprofile',
    '.oh-my-zsh/custom/themes/morelkai.zsh-theme':
        'zsh/themes/morelkai.zsh-theme',
    'Library/Application Support/com.mitchellh.ghostty/config.ghostty':
        'ghostty/config.ghostty',
    '.config/ghostty/themes/morelkai night':
        'ghostty/themes/morelkai night',
    '.config/ghostty/themes/morelkai day':
        'ghostty/themes/morelkai day',
    '.config/herdr/config.toml': 'herdr/config.toml',
}


def snapshot(directory):
    """Record directory entries and link text without following symlinks."""
    result = {}
    for path in directory.rglob('*'):
        key = str(path.relative_to(directory))
        if path.is_symlink():
            result[key] = ('link', os.readlink(path))
        elif path.is_file():
            result[key] = ('file', path.read_bytes())
        else:
            result[key] = ('directory',)
    return result


@unittest.skipUnless(os.uname().sysname == 'Darwin', 'macOS installer')
class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles-tests-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.home = self.root / 'home with spaces'
        self.home.mkdir()
        self.repo = self.root / 'checkout with spaces'
        self.repo.mkdir()
        shutil.copy2(REPO / 'install.sh', self.repo / 'install.sh')
        for directory in ('zsh', 'ghostty', 'herdr'):
            shutil.copytree(REPO / directory, self.repo / directory)

    def run_installer(self, *args, success=True):
        env = dict(os.environ, HOME=str(self.home))
        result = subprocess.run(
            ['/bin/bash', str(self.repo / 'install.sh'), *args],
            cwd=self.root, env=env, capture_output=True, text=True,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def backup_dirs(self):
        return list((self.home / '.local/state/dotfiles/backups').glob('*'))

    def assert_links(self):
        for target, source in LINKS.items():
            path = self.home / target
            self.assertTrue(path.is_symlink(), target)
            self.assertEqual(os.readlink(path), str(self.repo / source))

    def test_install_rerun_and_preserve_application_data(self):
        herdr = self.home / '.config/herdr'
        herdr.mkdir(parents=True)
        (herdr / 'session.json').write_text('session data')
        (herdr / 'herdr-server.log').write_text('log data')
        (herdr / 'session-snapshots').mkdir()
        (herdr / 'session-snapshots/snapshot.json').write_text('snapshot data')
        (herdr / 'herdr.sock').symlink_to('runtime-socket')
        original_data = snapshot(herdr)
        self.run_installer()
        self.assert_links()
        self.assertFalse(self.backup_dirs())
        installed_data = snapshot(herdr)
        del installed_data['config.toml']
        self.assertEqual(original_data, installed_data)
        before = snapshot(self.home)
        self.run_installer()
        self.assertEqual(before, snapshot(self.home))

    def test_dry_run_and_help_write_nothing(self):
        (self.home / '.zshrc').write_text('original')
        before = snapshot(self.home)
        result = self.run_installer('--dry-run')
        self.assertIn('Would back up:', result.stdout)
        self.assertIn('Would link:', result.stdout)
        self.run_installer('--help')
        self.assertEqual(before, snapshot(self.home))

    def test_dry_run_does_not_create_home(self):
        self.home = self.root / 'not created'
        self.run_installer('--dry-run')
        self.assertFalse(self.home.exists())

    def test_backup_files_and_incorrect_links_and_restore(self):
        (self.home / '.zshrc').write_text('original zsh config')
        previous_profile = self.root / 'previous-profile'
        previous_profile.write_text('profile contents')
        (self.home / '.zprofile').symlink_to(previous_profile)
        theme = self.home / '.config/ghostty/themes/morelkai day'
        theme.parent.mkdir(parents=True)
        theme.symlink_to('missing-theme')
        self.run_installer()
        self.assert_links()
        backups = self.backup_dirs()
        self.assertEqual(len(backups), 1)
        backup = backups[0]
        self.assertEqual((backup / '.zshrc').read_text(), 'original zsh config')
        self.assertEqual(os.readlink(backup / '.zprofile'), str(previous_profile))
        self.assertEqual(os.readlink(backup / theme.relative_to(self.home)), 'missing-theme')
        self.assertEqual(previous_profile.read_text(), 'profile contents')
        self.run_installer()
        self.assertEqual(self.backup_dirs(), backups)
        # The documented restoration replaces the link, not the repository file.
        source_before = (self.repo / 'zsh/.zshrc').read_bytes()
        subprocess.run(['mv', str(backup / '.zshrc'), str(self.home / '.zshrc')], check=True)
        self.assertFalse((self.home / '.zshrc').is_symlink())
        self.assertEqual((self.home / '.zshrc').read_text(), 'original zsh config')
        self.assertEqual((self.repo / 'zsh/.zshrc').read_bytes(), source_before)
        self.run_installer()
        self.assertEqual(len(self.backup_dirs()), 2)

    def test_directory_conflict_is_rejected_before_changes(self):
        (self.home / '.zshrc').write_text('keep this')
        (self.home / '.config/herdr/config.toml').mkdir(parents=True)
        before = snapshot(self.home)
        self.run_installer(success=False)
        self.assertEqual(before, snapshot(self.home))

    def test_directory_symlink_is_refused(self):
        (self.home / '.zshrc').symlink_to(self.root, target_is_directory=True)
        before = snapshot(self.home)
        self.run_installer(success=False)
        self.assertEqual(before, snapshot(self.home))

    def test_blocked_parent_is_rejected_before_changes(self):
        for dangling in (False, True):
            with self.subTest(dangling=dangling):
                parent = self.home / 'Library'
                if dangling:
                    parent.symlink_to('missing-directory')
                else:
                    parent.write_text('not a directory')
                before = snapshot(self.home)
                self.run_installer(success=False)
                self.assertEqual(before, snapshot(self.home))
                parent.unlink()

    def test_missing_source_is_rejected_before_changes(self):
        (self.repo / 'herdr/config.toml').unlink()
        before = snapshot(self.home)
        self.run_installer(success=False)
        self.assertEqual(before, snapshot(self.home))

    def test_invalid_arguments_write_nothing(self):
        before = snapshot(self.home)
        self.run_installer('--unknown', success=False)
        self.run_installer('--dry-run', 'extra', success=False)
        self.assertEqual(before, snapshot(self.home))


if __name__ == '__main__':
    unittest.main()
