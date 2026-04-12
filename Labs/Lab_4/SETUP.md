# Environment Setup — Semantic Web Labs (Lab 4 onwards)

This guide covers installing **Apache Jena** (for running SPARQL queries locally with `arq`) and **Protégé** (used from Lab 5 onwards). Follow the section for your operating system.

---

## Ubuntu

### 1. Verify Java 21

```bash
java -version
javac -version
```

Both must report version 21. If not, install it:

```bash
sudo apt install openjdk-21-jdk
```

Then re-run the version checks to confirm.

---

### 2. Download Apache Jena

Go to https://downloads.apache.org/jena/binaries/ and download `apache-jena-6.0.0.tar.gz`.

Or download directly from the terminal:

```bash
wget -P ~/Downloads https://downloads.apache.org/jena/binaries/apache-jena-6.0.0.tar.gz
```

---

### 3. Extract and place Jena

Create a folder for tools and extract the archive there:

```bash
mkdir -p ~/your-labs-folder/Apps
tar -xzf ~/Downloads/apache-jena-6.0.0.tar.gz -C ~/your-labs-folder/Apps/
```

Replace `~/your-labs-folder` with the actual path to your labs directory (e.g. `~/Documents/uni-labs/Sem\ II/semantic-web-labs`).

---

### 4. Set environment variables

Open `~/.bashrc` in any editor and append these two lines at the end:

```bash
export JENAROOT="/absolute/path/to/your-labs-folder/Apps/apache-jena-6.0.0"
export PATH="$JENAROOT/bin:$PATH"
```

Replace the path with the real location you extracted Jena into.

Then reload the file so the changes take effect in the current terminal:

```bash
source ~/.bashrc
```

From this point on, every new terminal will have `arq` and the other Jena tools on the PATH automatically.

---

### 5. Verify Jena

```bash
arq --version
```

Expected output: `Apache Jena version 6.0.0`

---

### 6. Download and install Protégé

Go to https://protege.stanford.edu/ and download the **Linux** desktop version (a `.tar.gz` archive).

Extract it into the same Apps folder:

```bash
tar -xzf ~/Downloads/Protege-*.tar.gz -C ~/your-labs-folder/Apps/
```

Make the launcher executable:

```bash
chmod +x ~/your-labs-folder/Apps/Protege-*/run.sh
```

Launch Protégé:

```bash
~/your-labs-folder/Apps/Protege-*/run.sh
```

---

### 7. Test the Lab 4 query

```bash
arq \
  --data=path/to/Lab_4/resources/startrek.rdf \
  --query=path/to/Lab_4/query.sparql
```

Expected result:

```
-----------------------------------------------
| actorName         | roleName                |
===============================================
| "Patrick Stewart" | "Capt. Jean-Luc Picard" |
-----------------------------------------------
```

---

---

## Windows

### 1. Verify Java 21

Open **Command Prompt** (`Win + R` → type `cmd` → Enter) and run:

```
java -version
javac -version
```

Both must report version 21. If not, download the JDK 21 installer from https://adoptium.net/, run it, and let the installer update your PATH automatically. Re-open Command Prompt and re-run the checks.

---

### 2. Download Apache Jena

Go to https://downloads.apache.org/jena/binaries/ and download `apache-jena-6.0.0.zip`.

---

### 3. Extract and place Jena

Right-click the downloaded zip → **Extract All…** → choose a destination, for example:

```
C:\semantic-web\Apps\apache-jena-6.0.0
```

After extraction your folder structure should look like:

```
C:\semantic-web\Apps\apache-jena-6.0.0\
  bin\
    arq.bat
    riot.bat
    ...
  lib\
  ...
```

---

### 4. Set environment variables

You need to add two environment variables: `JENAROOT` (pointing to the extracted folder) and add `%JENAROOT%\bin` to your `PATH`.

**Step-by-step:**

1. Press `Win + S`, search for **"Edit the system environment variables"**, open it.
2. Click **"Environment Variables…"** (bottom-right of the dialog).
3. In the **System variables** panel (bottom half), click **New…**:
   - Variable name: `JENAROOT`
   - Variable value: `C:\semantic-web\Apps\apache-jena-6.0.0`
   - Click **OK**.
4. Still in the System variables panel, find the variable named `Path`, select it, and click **Edit…**.
5. Click **New** and add:
   ```
   %JENAROOT%\bin
   ```
6. Click **OK** on all open dialogs to save.

> **Note:** Changes to system environment variables only take effect in **new** Command Prompt windows. Close and reopen cmd after this step.

---

### 5. Verify Jena

Open a **new** Command Prompt and run:

```
arq --version
```

Expected output: `Apache Jena version 6.0.0`

If you get `'arq' is not recognized`, double-check that `JENAROOT` points to the correct folder and that `%JENAROOT%\bin` was added to `Path` under **System variables** (not User variables).

---

### 6. Download and install Protégé

Go to https://protege.stanford.edu/ and download the **Windows** desktop version (a `.zip` archive).

Extract it anywhere convenient (e.g. `C:\semantic-web\Apps\Protege-5.6.9`).

Launch Protégé by double-clicking `Protege.exe` inside the extracted folder.

---

### 7. Test the Lab 4 query

Open Command Prompt, navigate to your labs folder, and run:

```
arq --data=Labs\Lab_4\resources\startrek.rdf --query=Labs\Lab_4\query.sparql
```

Expected result:

```
-----------------------------------------------
| actorName         | roleName                |
===============================================
| "Patrick Stewart" | "Capt. Jean-Luc Picard" |
-----------------------------------------------
```

---

## Quick reference

| Tool | Ubuntu launch | Windows launch |
|------|--------------|---------------|
| ARQ (SPARQL engine) | `arq` | `arq` (in cmd after PATH setup) |
| riot (RDF validator) | `riot --validate file.rdf` | `riot --validate file.rdf` |
| Protégé | `./run.sh` | `Protege.exe` |
