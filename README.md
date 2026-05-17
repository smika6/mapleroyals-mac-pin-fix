# MapleRoyals Pin Login Fix (macOS / CrossOver)

Can't get past the pin login screen in MapleRoyals on your Mac through CrossOver? This is the fix.

It replaces one Windows file (`iphlpapi.dll`) inside CrossOver with a patched version that makes the pin screen work. Once installed, you get:

- **A right-click Quick Action** — right-click `MapleRoyals.app` → done.
- **A double-click script on your Desktop** — for if you don't like right-clicking.

You can re-run it any time CrossOver updates and the pin breaks again.

> **Credit for the actual fix:** @xiaominghupan (Discord: `.colamint`).
> This repo just packages it up so it's easy to (re)apply.

---

## Who is this for?

You, if:
- You're on a **Mac** (this won't help on Windows or Linux)
- You play **MapleRoyals** through **CrossOver**
- You hit a wall at the **pin login screen** — it spins, freezes, or rejects valid pins

If that's not you, this won't do anything useful.

---

## SUPER NOOB GUIDE — start here if you've never used Terminal

### Step 1 — Download this repo

1. Scroll back to the **top of this page**.
2. Click the green **`< > Code`** button.
3. Click **`Download ZIP`** at the bottom of the menu that pops up.
4. Open your **Downloads** folder. You'll see a file called `mapleroyals-mac-pin-fix-main.zip`.
5. **Double-click the zip** to unzip it. You'll get a folder called `mapleroyals-mac-pin-fix-main`.

### Step 2 — Get the patched DLL file

You have two ways:

**Easy way:** Skip this step. The installer (Step 3) will offer to download the dll for you.

**Manual way:**
1. Open this link in your browser: **https://tinyurl.com/e633fsau**
2. Download the file. It's called **`iphlpapi.dll`**.
3. Leave it in your **Downloads** folder — the installer will find it there. (Or, if you prefer, drag it into the unzipped `mapleroyals-mac-pin-fix-main` folder from Step 1. Either works.)

### Step 3 — Run the installer

1. Open the **Terminal** app.
   - Press **Cmd + Space** (opens Spotlight search).
   - Type **`Terminal`**.
   - Hit **Enter**.
2. In the Terminal window, type this **exactly** — including the space at the end — but **DON'T press Enter yet**:
   ```
   bash 
   ```
   (yes, the word "bash" followed by a space)
3. Now go to Finder, open your **Downloads** folder, open the unzipped `mapleroyals-mac-pin-fix-main` folder.
4. **Drag the `install.sh` file** from Finder directly into the Terminal window. The full path will appear after `bash`.
5. **Now press Enter.**
6. Follow the prompts (just press Enter to accept the defaults).
7. When it says "Done!", you can close Terminal.

---

## How to actually use the fix

You have two ways. Pick whichever feels easier.

### Way 1 — Right-click on MapleRoyals.app

1. Open Finder.
2. Navigate to **`~/Applications/CrossOver/`** (in Finder: Go menu → Home → Applications → CrossOver).
3. **Right-click** on **`MapleRoyals.app`**.
4. Hover over **`Quick Actions`** (on some Macs it might be under **`Services`** instead).
5. Click **`Install iphlpapi.dll (MapleRoyals fix)`**.
6. macOS will ask for your Mac password. Type it.
7. You'll get a little notification: "iphlpapi.dll installed to CrossOver". Done.

### Way 2 — Double-click the Desktop script

1. On your Desktop, find **`Fix MapleRoyals Pin Login.command`**.
2. **Double-click it.**
3. *(First time only)* macOS may block it with a security warning. If so:
   - Right-click the file → **Open** → click **Open** in the popup.
   - Next time, double-clicking will work normally.
4. Type your Mac password when asked.
5. Notification appears. Done.

---

## When to re-run it

Run it again **any time** CrossOver updates itself or your pin login breaks. It's safe to run as many times as you want — it just copies the file over again.

---

## Uninstall

If you want to remove the Quick Action and the Desktop script:

1. Open Terminal (Cmd+Space → "Terminal" → Enter).
2. Type `bash ` (with a space), then drag `uninstall.sh` from the repo folder into Terminal.
3. Hit Enter.

> **Note:** This only removes the *installer tools*. The actual fix (the dll inside CrossOver) stays put — that's a good thing, it's why your pin login works. If you ever wanted to fully undo the fix, you'd reinstall CrossOver.

---

## What's in this repo

| File | What it does |
|------|-------------|
| `install.sh` | Installs the Quick Action and (optionally) the Desktop script |
| `uninstall.sh` | Removes them |
| `Fix MapleRoyals Pin Login.command` | The standalone double-click script |
| `Install iphlpapi.dll (MapleRoyals fix).workflow` | The macOS Quick Action bundle |
| `README.md` | This file |

---

## Where the scripts look for `iphlpapi.dll`

| Script | Search order |
|--------|-------------|
| **`install.sh`** | 1) Next to `install.sh` &nbsp; 2) `~/Downloads` (offers to move it) |
| **`Fix MapleRoyals Pin Login.command`** | 1) Same folder as the script &nbsp; 2) `~/Downloads` (asks to use-or-move) |
| **Right-click Quick Action** | 1) `~/Downloads` &nbsp; 2) File picker if not found |

You don't need to memorize this — drop the dll wherever (Downloads is easiest), and the scripts will figure it out.

## What this actually does (for the curious)

It copies your `iphlpapi.dll` over the top of:

```
/Applications/CrossOver.app/Contents/SharedSupport/CrossOver/lib/wine/i386-windows/iphlpapi.dll
```

That's the only thing happening. The patched dll handles the network call that the pin screen needs but the bundled one botches.

The right-click menu option is implemented as a macOS Automator **Quick Action** (a `.workflow` bundle) saved to `~/Library/Services/`. macOS reads that folder and adds anything in it to the right-click menu automatically.

Because `/Applications` is owned by root, copying needs your admin password — both the Quick Action and the `.command` script use `osascript ... with administrator privileges` to prompt you for it.

---

## Troubleshooting

**"The right-click menu doesn't show the option"**
- Log out of your Mac and log back in. macOS caches the Services menu and sometimes needs a kick.
- Make sure you're right-clicking a `.app` file (the Quick Action only appears on apps).

**"iphlpapi.dll not found" alert**
- You skipped Step 2. Download the dll from https://tinyurl.com/e633fsau and put it in your Downloads folder (or next to the script you're running).

**"Replacement failed" / "Could not copy"**
- Check CrossOver is installed at `/Applications/CrossOver.app` (not somewhere weird).
- Make sure you typed your Mac password correctly when prompted.

**"Pin login still broken after running the fix"**
- Fully quit MapleRoyals first, then run the fix, then re-launch.
- Restart CrossOver too if needed.

**"macOS says install.sh is from an unidentified developer"**
- It's a plain text shell script you can read — open it in TextEdit if you want to inspect it. To bypass: right-click the file → Open. Or just run it via `bash install.sh` from Terminal (the SUPER NOOB guide above) which doesn't trigger that warning.

---

## License

Do whatever you want with this. The patched dll is not mine to license — credit @xiaominghupan for that part.
