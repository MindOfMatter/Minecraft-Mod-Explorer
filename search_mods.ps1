# put the file in the instance (...\ATLauncher\instances\x)
# run it
# open the new ModLinks.html generated web page

clear

# Set the directory and JSON file path
$instanceDirectory = $PSScriptRoot
$modDirectory = Join-Path $instanceDirectory "mods"
$jsonFilePath = Join-Path $instanceDirectory "instance.json"

# Define a default "not found" icon URL
$defaultIconUrl = "https://cdn.vectorstock.com/i/1000x1000/15/03/page-not-found-sign-vector-14151503.webp" # Replace with the actual path to your default icon

# Define a default value for missing text
$defaultValue = "Not Available"

# Read JSON file with UTF-8 encoding
$jsonContent = Get-Content -Path $jsonFilePath -Raw -Encoding UTF8 | ConvertFrom-Json

# Calculate the size of the largest file
$maxSize = 0
foreach ($mod in $jsonContent.launcher.mods) {
    $modFile = Join-Path -Path $modDirectory -ChildPath $mod.file
    if (Test-Path $modFile) {
        $currentSize = (Get-Item $modFile).Length
        if ($currentSize -gt $maxSize) {
            $maxSize = $currentSize
        }
    }
}

# Start building the HTML content with sorting functionality
$htmlContent = @"
<html>
<head>
<title>Mod Links</title>
<meta charset='UTF-8'>
<style>
  body {
    font-family: Arial, sans-serif;
  }
  
  table {
    table-layout: fixed;
    width: 100%;
    border-collapse: collapse;
  }
  
  th, td {
    padding: 8px;
    text-align: left;
    border: 1px solid #ddd;
    word-wrap: break-word;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  
  th {
    background-color: #f2f2f2;
    cursor: pointer;
  }
  
  tr:hover {
    background-color: #e8e8e8;
  }
  
  .mod-image img {
    max-width: 100px;
    max-height: 100px;
    display: block;
    margin-left: auto;
    margin-right: auto;
  }
  
  .mod-size-bar {
    background-color: lightgray;
    width: 100%;
    height: 20px;
    position: relative;
    border-radius: 5px;
    overflow: hidden;
  }
  
  .mod-size-fill {
    background-color: #4CAF50;
    height: 100%;
    color: white;
    text-align: center;
    line-height: 20px;
    border-radius: 5px;
  }
  
  .mod-links a {
    color: blue;
    text-decoration: none;
  }
  
  .mod-links a:hover {
    text-decoration: underline;
  }

  .file-size-header {
    width: 75px; 
  }

  .image-header, .category-header, .links-header, .updated-at-header {
    width: 100px; 
  }

  .sort-icon {
    font-size: 12px; /* Adjust as needed */
    color: black; /* Adjust as needed */
  }

  /* CSS for sort arrows */
  th.asc .sort-icon {
    content: '▲'; /* up arrow */
  }

  th.desc .sort-icon {
    content: '▼'; /* down arrow */
  }

  /* Ensure the sort icons are hidden by default and only shown for the active sort column */
  .sort-icon {
    display: none;
  }

  th.asc .sort-icon,
  th.desc .sort-icon {
    display: inline-block;
  }

  /* Responsive design adjustments */
  @media screen and (max-width: 768px) {
    .mod-name, .mod-description, .mod-category, .mod-links, .mod-file-name {
      width: auto; /* Adjust width as needed */
    }

    /* Hide less important columns on small screens */
    .mod-file-name, .mod-updated-at {
      display: none;
    }
  }
</style>
<script>
var sortDirections = {};

function sortTable(columnIndex, isFileSize = false, isDate = false) {
    var table = document.getElementById('modTable');
    var th = table.getElementsByTagName('th');
    var tbody = table.tBodies[0];
    var rows = Array.from(tbody.rows);

    // Clear all th elements from 'asc' and 'desc' classes and remove arrows
    for (var i = 0; i < th.length; i++) {
        th[i].classList.remove('asc', 'desc');
        th[i].getElementsByClassName('sort-icon')[0].textContent = ''; // Clear existing arrows
    }

    // Add the appropriate class and arrow to the sorted column header
    var arrow = sortDirections[columnIndex] === 'asc' ? '▼' : '▲'; // Choose the correct arrow direction
    th[columnIndex].classList.add(sortDirections[columnIndex]);
    th[columnIndex].getElementsByClassName('sort-icon')[0].textContent = arrow; // Add the arrow

    // Toggle the sort directions and add class for visual indicator
    if (!sortDirections[columnIndex]) {
        sortDirections[columnIndex] = 'asc';
        th[columnIndex].classList.add('asc');
    } else if (sortDirections[columnIndex] === 'asc') {
        sortDirections[columnIndex] = 'desc';
        th[columnIndex].classList.add('desc');
    } else {
        sortDirections[columnIndex] = 'asc';
        th[columnIndex].classList.add('asc');
    }

    var dir = sortDirections[columnIndex];

    // Detach tbody for sorting
    table.removeChild(tbody);

    // Sorting logic based on the type of data (number, date, string)
    rows.sort(function (a, b) {
        var x, y;
        if (isFileSize) {
            x = parseFloat(a.cells[columnIndex].textContent);
            y = parseFloat(b.cells[columnIndex].textContent);
        } else if (isDate) {
            x = new Date(a.cells[columnIndex].textContent);
            y = new Date(b.cells[columnIndex].textContent);
        } else {
            x = a.cells[columnIndex].textContent.trim().toLowerCase();
            y = b.cells[columnIndex].textContent.trim().toLowerCase();
        }
        if (dir === 'asc') {
            return x > y ? 1 : x < y ? -1 : 0;
        } else {
            return x < y ? 1 : x > y ? -1 : 0;
        }
    });

    // Reattach tbody after sorting
    for (var i = 0; i < rows.length; i++) {
        tbody.appendChild(rows[i]);
    }

    table.appendChild(tbody);
}

// Function to initialize sort icons
function initializeSortIcons() {
    var ths = document.querySelectorAll('#modTable th');
    ths.forEach(function(th) {
        var span = document.createElement('span');
        span.className = 'sort-icon';
        th.appendChild(span); // Append the span to each header
    });
}

// Run the initialize function on DOMContentLoaded
document.addEventListener('DOMContentLoaded', function() {
    initializeSortIcons();
    sortTable(1); // Sort by Mod Name by default
});
</script>
</head>
<body>
<h1>Minecraft Mods</h1>
<table id='modTable' border='1'>
<thead>
<tr>
    <th class="image-header">Image</th>
    <th data-sortable="true" class="mod-name-header" onclick='sortTable(1)'>Mod Name</th>
    <th class="description-header">Description</th>
    <th class="category-header" onclick='sortTable(3)'>Category</th>
    <th class="file-size-header" onclick='sortTable(4, true)'>File Size (MB)</th>
    <th class="links-header">Links</th>
    <th class="file-name-header" onclick='sortTable(6)'>File Name</th>
    <th class="updated-at-header" onclick='sortTable(7, false, true)'>Updated At</th>
</tr>
</thead>
<tbody>
"@


# Process each mod in JSON
foreach ($mod in $jsonContent.launcher.mods) {
    $modFile = Join-Path -Path $modDirectory -ChildPath $mod.file
    if (Test-Path $modFile) {
        # Extract information
        $description = $mod.description

        # If modName is not defined, extract a more readable name from the file name
        $modName = if (-not [string]::IsNullOrWhiteSpace($mod.curseForgeProject.name)) {
            $mod.curseForgeProject.name
        } elseif (-not [string]::IsNullOrWhiteSpace($mod.modrinthProject.title)) {
            $mod.modrinthProject.title
        } elseif (-not [string]::IsNullOrWhiteSpace($mod.name)) {
            $mod.name
        } else {
            # Remove the .jar extension and any special characters or numbers
            $readableName = [System.IO.Path]::GetFileNameWithoutExtension($mod.file)
            $readableName = $readableName -replace '[-_]', ' ' # Replace hyphens and underscores with spaces
            $readableName -replace '[^A-Za-z\s]', '' # Replace special characters and numbers with empty string
        }

        $curseForgeSlug = $mod.curseForgeProject.slug
        $modrinthSlug = $mod.modrinthProject.slug

        # Safely extract and sort categories
        $categories = @()
        if ($mod.curseForgeProject -and $mod.curseForgeProject.categories) {
            $categories += $mod.curseForgeProject.categories.name | Sort-Object
        } elseif ($mod.modrinthProject -and $mod.modrinthProject.categories) {
            $categories += $mod.modrinthProject.categories | Sort-Object
        }
        $categoriesString = $categories -join "<br>"

        $modSize = (Get-Item $modFile).Length
        $fileSizeMB = [math]::Round($modSize / 1MB, 3)
        $sizePercentage = [math]::Round(($modSize / $maxSize) * 100, 2)

        # Determine the image URL
        $imageUrl = if (-not [string]::IsNullOrWhiteSpace($mod.curseForgeProject.logo.thumbnailUrl)) {
            $mod.curseForgeProject.logo.thumbnailUrl
        } elseif (-not [string]::IsNullOrWhiteSpace($mod.modrinthProject.icon_url)) {
            $mod.modrinthProject.icon_url
        } else {
            $defaultIconUrl
        }

        # Format the last modified date
        $lastModified = (Get-Item $modFile).LastWriteTime.ToString("yyyy/MM/dd HH:mm:ss")

        # Check if CurseForge or Modrinth links are available, otherwise use the default
        $curseForgeLink = if ([string]::IsNullOrWhiteSpace($curseForgeSlug)) { $defaultValue } else { "<a href='https://www.curseforge.com/minecraft/mc-mods/$curseForgeSlug' target='_blank' rel='noopener noreferrer'>CurseForge</a>" }
        $modrinthLink = if ([string]::IsNullOrWhiteSpace($modrinthSlug)) { $defaultValue } else { "<a href='https://modrinth.com/mod/$modrinthSlug' target='_blank' rel='noopener noreferrer'>Modrinth</a>" }

        # Add row to HTML table
        $htmlContent += @"
<tr>
    <td class='mod-image'><img src='$imageUrl' alt='Image Not Found' onerror='this.onerror=null;this.src="$defaultIconUrl";'></td>
    <td class='mod-name'>$modName</td>
    <td class='mod-description'>$(if ($description) { $description } else { $defaultValue })</td>
    <td class='mod-category'>$(if ($categoriesString) { $categoriesString } else { $defaultValue })</td>
    <td class='mod-size'>
        <div class='mod-size-bar'>
            <div class='mod-size-fill' style='width: $sizePercentage%;'>$fileSizeMB</div>
        </div>
    </td>
    <td class='mod-links'>$curseForgeLink, $modrinthLink</td>
    <td class='mod-file-name'>$(if ($mod.file) { "<a href='file:///$modFile'>$($mod.file)</a>" } else { $defaultValue })</td>
    <td class='mod-updated-at'>$lastModified</td>
</tr>
"@
    }
}

# Finish the HTML content
$htmlContent += @"
</tbody>
</table>
</body>
</html>
"@

# Check if HTML file exists and remove it
$htmlFilePath = "$instanceDirectory\ModLinks.html"
if (Test-Path $htmlFilePath) {
    Remove-Item $htmlFilePath
}

# Write the HTML content to a file
$htmlContent | Out-File -FilePath $htmlFilePath -Encoding utf8
