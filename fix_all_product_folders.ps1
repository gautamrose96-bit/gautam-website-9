# Comprehensive Script to Fix All Product Folder Names
# Renames Ayurveda folders to Art product names and copies to main website

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Fixing All Product Folder Names" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$sourceBase = "c:\Users\Shree\Desktop\gautam website 9\website product name and error correct\product"
$targetBase = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\product"

# Complete mapping of Ayurveda folder names to Art product names
$folderMappings = @{
    # Format: "Old Ayurveda Folder Name" = "New Art Product Name"
    "divya-amla-churna" = "Black Round Art"
    "divya-haridrakhand" = "Every Family Has A Story Wall Art"
    "divya-kutki-churna" = "Colorful Mandala Art Piece"
    "divya-mulethi-churna" = "Abstract Art 406"
    "divya-rasna-churna" = "Botanical Art Print"
    "divya-shuddh-shilajeet-sat" = "Light Pink Art Frame"
    "patanjali-kachi-ghani-mustard-oil" = "Dot Art Mandala Wall Decor"
    "patanjali-soya-chunks" = "Abstract Art Wall Decor"
    "patanjali-swet-mushli-churna" = "Floral Wall Art Frame"
    "patanjali-unpolished-urad-whole" = "Modern Wall Art Canvas"
    "love to our family" = "Krishna Maha Mantra Wall Art"
}

# Root level HTML files to folder mappings
$rootFileMappings = @{
    "3331.html" = @{ "Folder" = "Healing Quotes-2"; "NewName" = "3331.html" }
    "3352.html" = @{ "Folder" = "Healing Quotes-1"; "NewName" = "3352.html" }
    "3353.html" = @{ "Folder" = "Healing Quotes-3"; "NewName" = "3353.html" }
    "3477.html" = @{ "Folder" = "Namo-2 Wall Art"; "NewName" = "3477.html" }
    "3478.html" = @{ "Folder" = "Namokar Mantra Wall Art"; "NewName" = "3478.html" }
}

$totalFixed = 0
$totalErrors = 0

# Step 1: Process folders - rename and copy to main website
Write-Host "`nStep 1: Processing Ayurveda-named folders..." -ForegroundColor Yellow

foreach ($oldName in $folderMappings.Keys) {
    $newName = $folderMappings[$oldName]
    $sourcePath = Join-Path $sourceBase $oldName
    $targetPath = Join-Path $targetBase $newName
    
    if (Test-Path $sourcePath) {
        try {
            Write-Host "  Processing: $oldName → $newName" -ForegroundColor Cyan
            
            # Create target folder if doesn't exist
            if (-not (Test-Path $targetPath)) {
                New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
                Write-Host "    Created folder: $newName" -ForegroundColor Green
            }
            
            # Copy all HTML files from source to target
            $files = Get-ChildItem -Path $sourcePath -Filter "*.html" -Recurse
            foreach ($file in $files) {
                $targetFile = Join-Path $targetPath $file.Name
                
                # Read content and fix any remaining Ayurveda references
                $content = Get-Content -Path $file.FullName -Raw
                $modified = $false
                
                # Fix author if still patanjali
                if ($content -match 'name="author" content="patanjali"') {
                    $content = $content -replace 'name="author" content="patanjali"', 'name="author" content="gautamrose"'
                    $modified = $true
                }
                
                # Fix any remaining Ayurveda product names in URLs or content
                $ayurvedaPatterns = @(
                    @{ Pattern = 'patanjali-kachi-ghani-mustard-oil'; Replace = 'dot-art-mandala-wall-decor' }
                    @{ Pattern = 'patanjali-soya-chunks'; Replace = 'abstract-art-wall-decor' }
                    @{ Pattern = 'patanjali-swet-mushli-churna'; Replace = 'floral-wall-art-frame' }
                    @{ Pattern = 'patanjali-unpolished-urad-whole'; Replace = 'modern-wall-art-canvas' }
                    @{ Pattern = 'divya-amla-churna'; Replace = 'black-round-art' }
                    @{ Pattern = 'divya-haridrakhand'; Replace = 'every-family-has-a-story-wall-art' }
                    @{ Pattern = 'divya-kutki-churna'; Replace = 'colorful-mandala-art-piece' }
                    @{ Pattern = 'divya-mulethi-churna'; Replace = 'abstract-art-406' }
                    @{ Pattern = 'divya-rasna-churna'; Replace = 'botanical-art-print' }
                    @{ Pattern = 'divya-shuddh-shilajeet-sat'; Replace = 'light-pink-art-frame' }
                )
                
                foreach ($pattern in $ayurvedaPatterns) {
                    if ($content -match $pattern.Pattern) {
                        $content = $content -replace $pattern.Pattern, $pattern.Replace
                        $modified = $true
                    }
                }
                
                # Write file (modified or original)
                if ($modified) {
                    Set-Content -Path $targetFile -Value $content -Encoding UTF8 -Force
                    Write-Host "    Fixed & copied: $($file.Name)" -ForegroundColor Green
                } else {
                    Copy-Item -Path $file.FullName -Destination $targetFile -Force
                    Write-Host "    Copied: $($file.Name)" -ForegroundColor Green
                }
                $totalFixed++
            }
        }
        catch {
            Write-Host "    ERROR: $($_.Exception.Message)" -ForegroundColor Red
            $totalErrors++
        }
    } else {
        Write-Host "  Not found: $oldName" -ForegroundColor Red
        $totalErrors++
    }
}

# Step 2: Process root-level HTML files
Write-Host "`nStep 2: Processing root-level HTML files..." -ForegroundColor Yellow

foreach ($fileName in $rootFileMappings.Keys) {
    $mapping = $rootFileMappings[$fileName]
    $sourceFile = Join-Path $sourceBase $fileName
    $targetFolder = Join-Path $targetBase $mapping.Folder
    $targetFile = Join-Path $targetFolder $mapping.NewName
    
    if (Test-Path $sourceFile) {
        try {
            # Create target folder if doesn't exist
            if (-not (Test-Path $targetFolder)) {
                New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
                Write-Host "  Created folder: $($mapping.Folder)" -ForegroundColor Green
            }
            
            # Copy file
            Copy-Item -Path $sourceFile -Destination $targetFile -Force
            Write-Host "  Copied: $fileName → $($mapping.Folder)\$($mapping.NewName)" -ForegroundColor Green
            $totalFixed++
        }
        catch {
            Write-Host "  ERROR copying $fileName : $($_.Exception.Message)" -ForegroundColor Red
            $totalErrors++
        }
    } else {
        Write-Host "  Not found: $fileName" -ForegroundColor Red
        $totalErrors++
    }
}

# Step 3: Also copy the already-corrected HTML files from root of error correct folder
Write-Host "`nStep 3: Processing pre-corrected Healing Quotes files..." -ForegroundColor Yellow

$healingQuotesFiles = @(
    @{ Source = "Healing Quotes-1-3352.html"; TargetFolder = "Healing Quotes-1"; TargetFile = "3352.html" }
    @{ Source = "Healing Quotes-3-3353.html"; TargetFolder = "Healing Quotes-3"; TargetFile = "3353.html" }
    @{ Source = "Healing Quotes-4-3323.html"; TargetFolder = "Healing Quotes-4"; TargetFile = "3323.html" }
    @{ Source = "Healing Quotes-8-3347.html"; TargetFolder = "Healing Quotes-8"; TargetFile = "3347.html" }
    @{ Source = "Healing Quotes-10-3349.html"; TargetFolder = "Healing Quotes-10"; TargetFile = "3349.html" }
    @{ Source = "Healing Quotes-11-3321.html"; TargetFolder = "Healing Quotes-11"; TargetFile = "3321.html" }
    @{ Source = "Healing Quotes-12-3329.html"; TargetFolder = "Healing Quotes-12"; TargetFile = "3329.html" }
    @{ Source = "Healing Quotes-13-3394.html"; TargetFolder = "Healing Quotes-13"; TargetFile = "3394.html" }
    @{ Source = "Healing Quotes-15-3340.html"; TargetFolder = "Healing Quotes-15"; TargetFile = "3340.html" }
    @{ Source = "Healing Quotes-17-3335.html"; TargetFolder = "Healing Quotes-17"; TargetFile = "3335.html" }
    @{ Source = "Healing Quotes-20-3396.html"; TargetFolder = "Healing Quotes-20"; TargetFile = "3396.html" }
    @{ Source = "Healing Quotes-21-3344.html"; TargetFolder = "Healing Quotes-21"; TargetFile = "3344.html" }
    @{ Source = "Healing Quotes-23-3355.html"; TargetFolder = "Healing Quotes-23"; TargetFile = "3355.html" }
    @{ Source = "Healing Quotes-42-3397.html"; TargetFolder = "Healing Quotes-42"; TargetFile = "3397.html" }
    @{ Source = "Healing Quotes-45-3395.html"; TargetFolder = "Healing Quotes-45"; TargetFile = "3395.html" }
)

$parentFolder = "c:\Users\Shree\Desktop\gautam website 9\website product name and error correct"

foreach ($fileInfo in $healingQuotesFiles) {
    $sourceFile = Join-Path $parentFolder $fileInfo.Source
    $targetFolder = Join-Path $targetBase $fileInfo.TargetFolder
    $targetFile = Join-Path $targetFolder $fileInfo.TargetFile
    
    if (Test-Path $sourceFile) {
        try {
            # Create target folder if doesn't exist
            if (-not (Test-Path $targetFolder)) {
                New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
                Write-Host "  Created folder: $($fileInfo.TargetFolder)" -ForegroundColor Green
            }
            
            # Read and fix content
            $content = Get-Content -Path $sourceFile -Raw
            
            # Fix any remaining issues
            $content = $content -replace 'name="author" content="patanjali"', 'name="author" content="gautamrose"'
            $content = $content -replace 'name="author" content="Gautam Rose">>', 'name="author" content="gautamrose">'
            
            Set-Content -Path $targetFile -Value $content -Encoding UTF8 -Force
            Write-Host "  Copied: $($fileInfo.Source) → $($fileInfo.TargetFolder)\$($fileInfo.TargetFile)" -ForegroundColor Green
            $totalFixed++
        }
        catch {
            Write-Host "  ERROR copying $($fileInfo.Source) : $($_.Exception.Message)" -ForegroundColor Red
            $totalErrors++
        }
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Complete!" -ForegroundColor Green
Write-Host "Total files processed: $totalFixed" -ForegroundColor Green
Write-Host "Errors: $totalErrors" -ForegroundColor $(if ($totalErrors -gt 0) { "Red" } else { "Green" })
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`nAll product folders renamed and copied to main website:" -ForegroundColor Yellow
$folderMappings.GetEnumerator() | ForEach-Object {
    Write-Host "  $($_.Key) → $($_.Value)" -ForegroundColor White
}

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
