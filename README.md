# RustDesk Instance Manager GUI (rustdesk-multi-instance)

This project provides a graphical user interface (GUI) for managing multiple RustDesk instances on Windows. The tool allows you to select different configurations (instances) for RustDesk, enabling you to switch between private and public relay servers or manage separate environments.

![image](https://github.com/user-attachments/assets/67b48997-282a-4aea-a31f-2c4ae15dd80b)


---

## Features

- **Browse and Select RustDesk Executable**  
  Easily choose the `RustDesk.exe` executable for launching instances.

- **Instance Management**  
  - Browse and select a directory containing RustDesk instances.  
  - Create new RustDesk instances with independent configurations.  
  - Launch a selected instance directly from the GUI.

- **Configuration Isolation**  
  Each instance has its own `APPDATA` directory to maintain isolated settings.

---

## Prerequisites

- **Windows OS**  
  The script is designed to run on Windows operating systems.

- **RustDesk**  
  Ensure that RustDesk is installed on your system. You can download it from [RustDesk Official Website](https://rustdesk.com/).

- **PowerShell**  
  Requires **PowerShell 4.x** or later.  

---

## Installation

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/suuhm/rustdesk-multi-instance.git
   cd rustdesk-multi-instance
   ```

2. **Run the Script**  
   Open PowerShell as Administrator and execute the script:  
   ```powershell
   .\rustdesk-multi-instance.ps1
   ```

---

## Usage

1. **Browse RustDesk Executable**  
   - Click the "Browse RustDesk.exe" button to select the RustDesk executable file.

2. **Select Instance Directory**  
   - Use "Browse Instance Path" to choose a directory where RustDesk instances are stored.

3. **Create New Instances**  
   - Use the "Create Instance" button to set up a new instance.  
   - Default configurations will be copied to the new instance folder.

4. **Launch an Instance**  
   - Select an instance from the list and click "Start Instance" to launch RustDesk with the selected configuration.

---

## How It Works

- The tool temporarily modifies the `APPDATA` environment variable to point to the selected RustDesk instance.  
- This allows RustDesk to run with a unique configuration for each instance.

---

## Notes

- Ensure the directory containing instances has appropriate permissions for read/write access.  
- Each instance's configuration is stored in a separate folder to avoid conflicts.

---

## Contributing

Contributions are welcome!  
If you'd like to improve the script, submit a pull request or open an issue.

---


Let me know if you want me to adjust anything!
