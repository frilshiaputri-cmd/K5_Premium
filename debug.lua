-- DEBUG ALTERNATIF - Tanpa hookmetamethod (Aman buat Delta)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

print("========== DEBUG IRON SOUL (NO HOOK) ==========")

-- 1. Cek struktur Remotes
local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if remotes then
    print("✅ Remotes folder ditemukan")
    for _, obj in ipairs(remotes:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("  [" .. obj.ClassName .. "]", obj:GetFullName())
        end
    end
else
    print("❌ Remotes folder GAK ADA")
end

-- 2. Cek isi folder Codes
print("\n--- Isi Remotes.Codes ---")
local codesFolder = remotes and remotes:FindFirstChild("Codes")
if codesFolder then
    for _, obj in ipairs(codesFolder:GetChildren()) do
        print("  " .. obj.Name .. " (" .. obj.ClassName .. ")")
    end
else
    print("❌ Remotes.Codes GAK ADA")
end

-- 3. Cek Claim remote
print("\n--- Cek Claim Remote ---")
local claimRemote = codesFolder and codesFolder:FindFirstChild("Claim")
if claimRemote then
    print("✅ Claim remote ditemukan: " .. claimRemote.ClassName)
else
    print("❌ Claim remote GAK ADA")
end

-- 4. Cek apakah ada ModuleScript buat validasi kode
print("\n--- Cek ModuleScript terkait Code ---")
for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("ModuleScript") then
        local name = string.lower(obj.Name)
        if string.find(name, "code") or string.find(name, "claim") or string.find(name, "redeem") then
            print("  [ModuleScript]", obj:GetFullName())
        end
    end
end

-- 5. Cek inventory player (mungkin item udah masuk tapi gak keliatan)
print("\n--- Player Data ---")
for _, child in ipairs(lp:GetChildren()) do
    print("  " .. child.ClassName .. ": " .. child.Name)
end

print("\n========== END DEBUG ==========")
print(">>> Kirim hasil ini ke aku <<<")
