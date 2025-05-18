## Kali in Batch

A simulated Kali Linux environment in batch.

### Dependencies

- [Nmap](https://nmap.org/)
- [Git for Windows](https://git-scm.com/download/win) (make sure you get Git Bash and use a system-wide installation)
- [Vim (optional)](https://www.vim.org/download.php)

### Usage

Clone the repository:
```bash
git clone https://codeberg.org/Kali-in-Batch/kali-in-batch.git
```
```bash	
cd kali-in-batch
```

Then, run `kali_in_batch.bat` inside the src directory.
DO NOT MOVE THE FILE OUTSIDE THE SRC DIRECTORY.

### Features

- [x] Networking with ping and nmap
- [x] Package management with pkg
- [x] File management with cp, mv, rm, and mkdir
- [x] Text editing with vim or any other text editor
- [x] Terminal control with clear, exit, and help
- [x] System information with uname and whoami
