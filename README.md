# ⚡ SysHub UI Library

<div align="center">

![Version](https://img.shields.io/badge/version-3.0.1-008cff?style=for-the-badge)
![Roblox](https://img.shields.io/badge/Roblox-Luau-00a2ff?style=for-the-badge&logo=roblox&logoColor=white)
![Compatibility](https://img.shields.io/badge/Executor-Universal-22c55e?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blueviolet?style=for-the-badge)

**Next-Gen Obsidian Dashboard • SysHub Electric Blue Theme**  
*Dual-Column Symmetrical Grid • Compact Modern Sidebar • Accordion Cards • 100% WindUI Compatible*

</div>

---

## 🌟 Fitur Utama (Key Features)

- 🎨 **Obsidian Matte & Electric Blue Palette**: Perpaduan tema gelap obsidian dengan aksen biru elektrik modern (*SysHub S-Monogram signature*).
- 📐 **Dual-Column Symmetrical Grid**: Penataan 2 kolom (Kiri & Kanan) dengan kalkulasi margin dan jarak tengah (*gap*) yang presisi dan seimbang.
- 📁 **Collapsible Accordion Cards**: Setiap section dapat dibuka-tutup dengan animasi transisi yang mulus (*smooth tweening*).
- 🔍 **Instant Search Bar**: Filter fitur dan tombol secara langsung (*real-time search*).
- ⚡ **Full WindUI API Compatibility**: Kompatibel penuh dengan sintaks WindUI—tinggal ganti link loader tanpa perlu menulis ulang script Anda.
- 📱 **Mobile & Desktop Friendly**: Mendukung draggable window, navigasi touch layar sentuh, dan tombol pintas keyboard (*Keybind toggle*).
- 🛡️ **Universal Executor Support**: Berfungsi mulus di berbagai executor (Delta, Fluxus, Wave, Codex, Arceus X, Synapse, Solara, dll.).

---

## 🚀 Cara Pemasangan (Quick Start)

Cukup tambahkan baris berikut di paling awal script Anda:

```lua
local SysHubUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/rockhub969/SysHubUI/refs/heads/main/SysHubUI.lua"))()
```

> [!TIP]
> **Migrasi dari WindUI:** Jika script Anda sebelumnya menggunakan WindUI, cukup tambahkan alias ini:
> ```lua
> local WindUI = SysHubUI
> ```
> Seluruh script lama Anda akan langsung tampil menggunakan UI baru SysHub!

---

## 📖 Contoh Penggunaan Lengkap (Full Boilerplate)

Berikut adalah contoh lengkap cara membuat Window, Tab, Section 2 Kolom, serta semua elemen kontrol:

```lua
-- 1. Muat Library SysHubUI
local SysHubUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/rockhub969/SysHubUI/refs/heads/main/SysHubUI.lua"))()

-- 2. Inisialisasi Window Utama
local Window = SysHubUI:CreateWindow({
    Title = "My Game Hub",
    Subtitle = "Universal Edition • v1.0",
    Footer = "SysHub UI Library",
    Keybind = Enum.KeyCode.RightControl, -- Tombol keyboard untuk minimize/maximize
    Size = UDim2.fromOffset(760, 490)
})

-- 3. Membuat Tab
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "rbxassetid://10723407389" -- Icon ID atau Lucide Icon
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "rbxassetid://10747373176",
    PlayerProfile = true -- Otomatis memunculkan Avatar Card & Session Info
})

-- 4. Membuat Section / Groupbox (Layout 2 Kolom Kiri & Kanan)
local LeftSec = MainTab:Section({
    Title = "Farming Automation",
    Side = "Left",  -- "Left" untuk kolom kiri
    Opened = true   -- Status awal: terbuka
})

local RightSec = MainTab:Section({
    Title = "Player Modifications",
    Side = "Right", -- "Right" untuk kolom kanan
    Opened = true
})

-- ==============================================================================
-- KOMPONEN KONTROL (ELEMENTS)
-- ==============================================================================

-- A. Button (Tombol Aksi)
LeftSec:Button({
    Title = "Instant Kill All Mobs",
    Callback = function()
        print("Tombol Kill All ditekan!")
        SysHubUI:Notify({
            Title = "Combat",
            Content = "Semua musuh berhasil dieliminasi!",
            Duration = 2.5
        })
    end
})

-- B. Toggle (Saklar Nyala/Mati)
LeftSec:Toggle({
    Title = "Auto Attack & Farm",
    Default = false,
    Callback = function(state)
        print("Status Auto Farm:", state)
    end
})

-- C. Slider (Pengatur Nilai Angka)
RightSec:Slider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Suffix = " spd",
    Callback = function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
})

-- D. Dropdown (Menu Pilihan)
local LocationDropdown = RightSec:Dropdown({
    Title = "Pilih Lokasi Teleport:",
    Values = {"Spawn Point", "Forest Area", "Desert Oasis", "Boss Arena"},
    Value = "Spawn Point",
    Multi = false, -- Set true untuk multi-select
    Callback = function(selected)
        print("Target teleport dipilih:", selected)
    end
})

-- Memperbarui isi dropdown secara dinamis:
-- LocationDropdown:Refresh({"Area Baru 1", "Area Baru 2"}, true)
-- LocationDropdown:SetValue("Area Baru 1")

-- E. Text Input (Kotak Ketik Teks)
RightSec:Input({
    Title = "Custom Teleport Player",
    Placeholder = "Ketik username player...",
    Callback = function(text)
        print("Player target:", text)
    end
})

-- F. Paragraph (Kotak Informasi / Teks Pengumuman)
local InfoBox = LeftSec:Paragraph({
    Title = "Informasi Script",
    Desc = "Pastikan executor Anda memiliki FPS unlocker untuk pengalaman terbaik."
})

-- Memperbarui teks paragraf secara dinamis:
-- InfoBox:SetDesc("Status: Server sedang diperbarui...")

-- G. Notifikasi Pop-up
SysHubUI:Notify({
    Title = "SysHub Loaded!",
    Content = "Selamat datang! Tekan RightControl untuk sembunyikan UI.",
    Duration = 4
})
```

---

## 🛠️ Dokumentasi Komponen (API Reference)

| Komponen | Method Utama | Deskripsi |
| :--- | :--- | :--- |
| **`Window`** | `CreateWindow(config)` | Membuat container GUI utama dengan header, search, dan sidebar. |
| **`Tab`** | `Window:Tab(config)` | Menambahkan tab menu pada navigasi sidebar. |
| **`Section`** | `Tab:Section(config)` | Membuat card box 2-kolom (`Side = "Left"` atau `"Right"`). |
| **`Button`** | `Section:Button(config)` | Tombol interaktif sekali klik. |
| **`Toggle`** | `Section:Toggle(config)` | Saklar toggle boolean (`true`/`false`). Mendukung `:Set(val)`. |
| **`Slider`** | `Section:Slider(config)` | Penggeser angka dengan drag responsif. Mendukung `:Set(val)`. |
| **`Dropdown`** | `Section:Dropdown(config)` | Selector item dinamis. Mendukung `:Refresh(list, true)` dan `:SetValue(item)`. |
| **`Input`** | `Section:Input(config)` | Kotak input teks. Mendukung `:Set(text)`. |
| **`Paragraph`** | `Section:Paragraph(config)` | Label teks informatif. Mendukung `:SetTitle(t)` dan `:SetDesc(d)`. |
| **`Notify`** | `SysHubUI:Notify(config)` | Menampilkan notifikasi popup elegan di pojok layar. |

---

## 📄 Lisensi (License)

Proyek ini dirilis di bawah lisensi **MIT License**. Siapapun bebas menggunakan, memodifikasi, dan mendistribusikannya untuk project hub/script Roblox Anda.

<div align="center">

Dibuat dengan ❤️ oleh **[rockhub969](https://github.com/rockhub969)** • Powered by **SysHub**

</div>
