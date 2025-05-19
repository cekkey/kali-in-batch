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

Once you have set up Kali in Batch, try installing this package in the Kali in Batch shell:
```bash
pkg install elf-exec
```
This package allows you to execute Linux binaries using WSL.
Run it:
```bash
exec elf-exec
```

### Features

- [x] Networking with ping and nmap
- [x] Package management with pkg
- [x] File management with cp, mv, rm, and mkdir
- [x] Text editing with vim or any other text editor
- [x] Terminal control with clear, exit, and help
- [x] System information with uname and whoami

---

This project is **NOT** associated with Kali Linux or any of it's contributors.
