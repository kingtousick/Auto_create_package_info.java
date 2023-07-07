Write-Host "=================작업시작================"
# 사용자로부터 프로젝트 폴더 경로 입력 받기
$project_root = Read-Host "프로젝트 폴더 경로를 입력하세요"

if (-not (Test-Path $project_root -PathType Container)) {
    Write-Host "프로젝트 폴더를 찾을 수 없습니다."
    exit
}

# 패키지 루트 디렉토리 설정
$package_root = Join-Path -Path $project_root -ChildPath "src\main\java"

# 패키지 폴더 배열 생성
$package_folders = Get-ChildItem -Directory -Recurse -Path $package_root | Select-Object -ExpandProperty FullName

# java 패키지 폴더들에 대해 package-info.java 파일 생성
$package_folders | ForEach-Object {
    $package_path = $_.Substring($package_root.Length + 1).Replace('\', '.')
    $package_info_file = Join-Path -Path $_ -ChildPath "package-info.java"

    # package-info.java 파일이 이미 존재하는지 확인
    if (Test-Path $package_info_file -PathType Leaf) {
        Write-Host "패키지 $package_path의 package-info.java 파일이 이미 존재합니다."
    }
    else {
        Write-Host "패키지 $package_path에 package-info.java 파일을 생성합니다."
        $package_info_content = "/**`n *  JAVA DOC 를 정의한다.`n */`n`n" + "package $package_path;`n"
        $package_info_content | Out-File -FilePath $package_info_file -Encoding UTF8
    }
}

Write-Host "=================작업완료================"
