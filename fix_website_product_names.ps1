# PowerShell Script to Fix Website Product Names
# This script renames Ayurveda folders to Art product names and fixes HTML content

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Fixing Website Product Names" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$sourcePath = "c:\Users\Shree\Desktop\gautam website 9\website product name and error correct\product"
$targetPath = "c:\Users\Shree\Desktop\gautam website 9\gautamrose website\www.gautamrose.net\product"

# Define the folder mappings (Ayurveda Name -> Art Product Name)
$folderMappings = @{
    "divya-amla-churna" = "Black Round Art"
    "divya-haridrakhand" = "Every Family Has A Story Wall Art"
    "divya-kutki-churna" = "Colorful Mandala Art Piece"  # Need to create proper name
    "divya-mulethi-churna" = "Abstract Art 406"
    "divya-rasna-churna" = "Botanical Art Print"
    "divya-shuddh-shilajeet-sat" = "Light Pink Art Frame"
    "patanjali-kachi-ghani-mustard-oil" = "Dot Art Mandala Wall Decor"
    "patanjali-soya-chunks" = "Abstract Art Wall Decor"
    "patanjali-swet-mushli-churna" = "Floral Wall Art Frame"
    "patanjali-unpolished-urad-whole" = "Modern Wall Art Canvas"
    "love to our family" = "Krishna Maha Mantra Wall Art"
}

# Define file mappings (Folder -> FileID -> New Title, Description, Keywords)
$productFixes = @{
    "patanjali-kachi-ghani-mustard-oil" = @{
        "1387.html" = @{
            "title" = "Dot Art Mandala Wall Decor - Buy Online"
            "description" = "Beautiful dot art mandala wall decor - Buy authentic mandala artwork from gautamrose.net for your home and office decoration."
            "keywords" = "dot art, mandala wall decor, mandala art, wall art, home decor, gautamrose"
        }
    }
    "divya-kutki-churna" = @{
        "87.html" = @{
            "title" = "Colorful Mandala Art Piece - Buy Online"
            "description" = "Beautiful colorful mandala art piece - Buy authentic mandala artwork from gautamrose.net for your home and office decoration."
            "keywords" = "colorful mandala, mandala art, wall art, home decor, gautamrose"
        }
    }
}

$fixedCount = 0
$errorCount = 0

# Step 1: Fix HTML content in source files
Write-Host "`nStep 1: Fixing HTML content..." -ForegroundColor Yellow

foreach ($folder in $productFixes.Keys) {
    foreach ($file in $productFixes[$folder].Keys) {
        $filePath = Join-Path (Join-Path $sourcePath $folder) $file
        if (Test-Path $filePath) {
            try {
                $content = Get-Content -Path $filePath -Raw -ErrorAction SilentlyContinue
                if ($content) {
                    $modified = $false
                    $fixes = $productFixes[$folder][$file]
                    
                    # Fix title
                    if ($fixes.title) {
                        $content = $content -replace '<title>[^<]*</title>', "<title>$($fixes.title)</title>"
                        $modified = $true
                    }
                    
                    # Fix description
                    if ($fixes.description) {
                        $content = $content -replace 'name="description" content="[^"]*"', "name=`"description`" content=`"$($fixes.description)`""
                        $modified = $true
                    }
                    
                    # Fix keywords
                    if ($fixes.keywords) {
                        $content = $content -replace 'name="keywords" content="[^"]*"', "name=`"keywords`" content=`"$($fixes.keywords)`""
                        $modified = $true
                    }
                    
                    # Fix author
                    $content = $content -replace 'name="author" content="[^"]*"', 'name="author" content="gautamrose"'
                    $modified = $true
                    
                    if ($modified) {
                        Set-Content -Path $filePath -Value $content -Encoding UTF8 -Force
                        Write-Host "  Fixed: $folder\$file" -ForegroundColor Green
                        $fixedCount++
                    }
                }
            }
            catch {
                Write-Host "  Error fixing $folder\$file : $($_.Exception.Message)" -ForegroundColor Red
                $errorCount++
            }
        }
    }
}

# Step 2: Rename folders and copy to main website
Write-Host "`nStep 2: Renaming folders and copying to main website..." -ForegroundColor Yellow

foreach ($oldName in $folderMappings.Keys) {
    $newName = $folderMappings[$oldName]
    $sourceFolder = Join-Path $sourcePath $oldName
    $targetFolder = Join-Path $targetPath $newName
    
    if (Test-Path $sourceFolder) {
        try {
            # Check if target already exists
            if (Test-Path $targetFolder) {
                Write-Host "  Target already exists: $newName - Merging files..." -ForegroundColor Yellow
                # Copy files from source to target
                $files = Get-ChildItem -Path $sourceFolder -Filter "*.html"
                foreach ($file in $files) {
                    $destFile = Join-Path $targetFolder $file.Name
                    Copy-Item -Path $file.FullName -Destination $destFile -Force
                    Write-Host "    Copied: $($file.Name)" -ForegroundColor Green
                    $fixedCount++
                }
            } else {
                # Create new folder with art name and copy content
                New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
                $files = Get-ChildItem -Path $sourceFolder -Filter "*.html"
                foreach ($file in $files) {
                    $destFile = Join-Path $targetFolder $file.Name
                    Copy-Item -Path $file.FullName -Destination $destFile -Force
                    Write-Host "  Created: $newName\$($file.Name)" -ForegroundColor Green
                    $fixedCount++
                }
            }
        }
        catch {
            Write-Host "  Error processing $oldName : $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    } else {
        Write-Host "  Source not found: $oldName" -ForegroundColor Red
        $errorCount++
    }
}

# Step 3: Copy the already-fixed HTML files at root level
Write-Host "`nStep 3: Copying fixed HTML files..." -ForegroundColor Yellow

$rootFiles = @(
    @{ "Source" = "3331.html"; "TargetFolder" = "Healing Quotes-2"; "TargetFile" = "3331.html" },
    @{ "Source" = "3352.html"; "TargetFolder" = "Healing Quotes-1"; "TargetFile" = "3352.html" },
    @{ "Source" = "3353.html"; "TargetFolder" = "Healing Quotes-3"; "TargetFile" = "3353.html" },
    @{ "Source" = "3477.html"; "TargetFolder" = "Namo-2 Wall Art"; "TargetFile" = "3477.html" },
    @{ "Source" = "3478.html"; "TargetFolder" = "Namokar Mantra Wall Art"; "TargetFile" = "3478.html" }
)

foreach ($fileInfo in $rootFiles) {
    $sourceFile = Join-Path $sourcePath $fileInfo.Source
    $targetFolder = Join-Path $targetPath $fileInfo.TargetFolder
    $targetFile = Join-Path $targetFolder $fileInfo.TargetFile
    
    if (Test-Path $sourceFile) {
        try {
            if (-not (Test-Path $targetFolder)) {
                New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
            }
            Copy-Item -Path $sourceFile -Destination $targetFile -Force
            Write-Host "  Copied: $($fileInfo.Source) -> $($fileInfo.TargetFolder)\$($fileInfo.TargetFile)" -ForegroundColor Green
            $fixedCount++
        }
        catch {
            Write-Host "  Error copying $($fileInfo.Source) : $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Fix Complete!" -ForegroundColor Cyan
Write-Host "Files Fixed/Copied: $fixedCount" -ForegroundColor Green
Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host "==========================================" -ForegroundColor Cyan

# Pause to see results
Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
