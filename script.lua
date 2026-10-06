-- =====================================================================
-- AUTO CLAIM CODE — IRON SOUL: DUNGEON  (executor Delta / mobile)
-- Khusus Iron Soul: WAJIB jeda 4-5 detik antar kode,
-- kalau tidak muncul error "Too many actions".
-- Syarat: tutorial selesai + popup "Enter Code" sudah dibuka.
-- =====================================================================

local Players = game:GetService("Players")
local player  = Players.LocalPlayer
local pg      = player:WaitForChild("PlayerGui")

-- ---------------------------------------------------------------------
-- PENGATURAN
-- ---------------------------------------------------------------------
local JEDA_MIN   = 4.0    -- jeda minimum antar kode (detik)
local JEDA_MAX   = 5.0    -- jeda maksimum antar kode (detik)
local SATU_KODE  = false  -- true = hanya redeem 1 kode per Execute
                          -- false = redeem semua kode berurutan dgn jeda

local CODES = {
"runekify",
"Dray28",
"RIKUSOULS",
"Ahjughh",
"T3nsei",
"Ghifa",
"ALLWAONIRONSOUL",
"Sukunay",
"MERGIXS",
"SIGURIH",
"CA2",
"Lulzsec",
"druscxlla",
"MAHAFEY",
"LALAGANG",
"Luthador2121",
"AAM",
"ToadPlaysGamesTTV",
"Uzi",
"TT_Mentally_ill_K.N",
"luknojo",
"Zeny",
"Clipz7112",
"PaPaX",
"Ryu",
"Chrisss",
"Ryokenn",
"DEI_Yumeko",
"Gryffin",
"ARKANGHEL",
"tony_vt",
"ReyPomuchi",
"Freca",
"Shan",
"TT_oratttt",
"Lifauzi",
"Ewaa",
"FRanime_OFFICIEL",
"Maple",
"Fujiesane",
"VeeruChan",
"HELOS",
"LezoCr",
"ARES",
"Laplace",
"Deco",
"dasher",
"Nyxaria",
"ProfGab",
"SUB2BLAZESTARS",
"Nothing",
"Dism",
"FannTzy",
"Darkfeniks",
"Sneptuno",
"SUPER MBUD",
"Marcell",
"Markbhatra",
"DrekathSenpai",
"Maniaco_666",
"Kiota2",
"WerNate",
"Ascart",
"Sweetiee24",
"Monarch",
"Aetherix",
"SUB2MULTIST789",
"Heso",
"RENZEI100",
"Skywinter86",
"Ghelayyy",
"Heartguard",
"RaykorBR",
"ZARGAKSTONE",
"aldoDM",
"Kurt",
"7Ds_Fangku",
"scarletditadora",
"Kuyabing",
"smiley",
"Sine",
"GT_HANNI",
"Erijero",
"DanoNano",
"WettySNK",
"Astral",
"obe",
"Dekday",
"Qyuu",
"Qwynne",
"PapiJoy",
"Taalonely",
"Darren",
"MADUNN",
"LZZ_019BEST",
"NisardHelpOnlyWoman",
"Staysmoovey",
"Les",
"Bebek",
"PepCalcot",
"Shirooo0312_IRONSOUL",
"omjiwa",
}

-- =====================================================================
-- FUNGSI PENCARIAN KOMPONEN
-- =====================================================================
local function cariKotakKode()
    for _, o in ipairs(pg:GetDescendants()) do
        if o:IsA("TextBox") then
            local ph = string.lower(o.PlaceholderText or "")
            local nm = string.lower(o.Name)
            if ph:find("code") or nm:find("code") or ph:find("enter") then
                return o
            end
        end
    end
end

local function cariTombolConfirm(box)
    local kandidat = {}
    for _, o in ipairs(pg:GetDescendants()) do
        if o:IsA("TextButton") or o:IsA("ImageButton") then
            local label = string.lower((o.Text ~= "" and o.Text) or o.Name)
            if label:find("confirm") or label:find("submit")
               or label:find("redeem") or label:find("claim") then
                table.insert(kandidat, o)
            end
        end
    end
    if box then
        local leluhur = {}
        for p = box, nil, -1 do leluhur[p] = true end
        for _, c in ipairs(kandidat) do
            if leluhur[c.Parent] then return c end
        end
    end
    return kandidat[1]
end

local function daftarRemoteKode()
    local r = {}
    for _, o in ipairs(pg:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            local nm = string.lower(o.Name)
            if nm:find("code") or nm:find("redeem") or nm:find("claim") then
                table.insert(r, o)
            end
        end
    end
    return r
end

-- =====================================================================
-- CARI KOMPONEN
-- =====================================================================
local box = cariKotakKode()
if not box then
    warn("[iron-soul] Kotak 'Enter Code' tidak ditemukan. "
      .. "Buka popup ikon Discord dulu, lalu Execute ulang.")
    return
end

local btn     = cariTombolConfirm(box)
local remotes = daftarRemoteKode()

print(("[iron-soul] box=%s | confirm=%s | remote=%d")
    :format(box:GetFullName(),
            btn and btn:GetFullName() or "nil",
            #remotes))
print(("[iron-soul] mode: %s | jeda %.1f-%.1f detik")
    :format(SATU_KODE and "1 kode per Execute" or "semua kode berurutan",
            JEDA_MIN, JEDA_MAX))

-- =====================================================================
-- FUNGSI: kirim satu kode
-- =====================================================================
local function kirimKode(code)
    -- Jalur A: lewat GUI (isi kotak + tekan Confirm)
    box:CaptureFocus()
    task.wait(0.2)
    box.Text = code
    task.wait(0.2)
    box:ReleaseFocus()
    task.wait(0.2)

    if btn and (btn:IsA("TextButton") or btn:IsA("ImageButton")) then
        btn:Activate()
    end

    -- Jalur B: fire RemoteEvent langsung (cadangan)
    for _, r in ipairs(remotes) do
        pcall(function() r:FireServer(code) end)
    end

    print(("[iron-soul] kode '%s' terkirim."):format(code))
end

-- =====================================================================
-- LOOP UTAMA
-- =====================================================================
if SATU_KODE then
    -- Mode 1 kode per Execute: baca kode berikutnya dari daftar yang belum
    -- dicoba (disimpan di atribut lokal supaya lanjut di run berikutnya).
    if not player:GetAttribute("IronSoulIdx") then
        player:SetAttribute("IronSoulIdx", 0)
    end
    local idx = player:GetAttribute("IronSoulIdx") + 1
    if idx > #CODES then
        print("[iron-soul] Semua kode sudah dicoba. Reset atribut untuk mulai ulang.")
        return
    end
    kirimKode(CODES[idx])
    player:SetAttribute("IronSoulIdx", idx)
    print(("[iron-soul] progress %d/%d. Execute lagi untuk kode berikutnya.")
        :format(idx, #CODES))
else
    -- Mode semua kode berurutan dengan jeda acak 4-5 detik.
    for i, code in ipairs(CODES) do
        print(("[iron-soul] (%d/%d) %s"):format(i, #CODES, code))
        kirimKode(code)

        if i < #CODES then
            local jeda = JEDA_MIN + math.random() * (JEDA_MAX - JEDA_MIN)
            print(("[iron-soul] tunggu %.2f detik sebelum kode berikutnya...")
                :format(jeda))
            task.wait(jeda)
        end
    end
    print("[iron-soul] SELESAI.")
end
