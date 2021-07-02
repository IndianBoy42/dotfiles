function extract --description 'Expand or extract bundled & compressed files'
  set --local ext (echo $argv[1] | awk -F. '{print $NF}')
  test -n "$argv[2]";
  and set --local tar_to "-C $argv[2]"
  and set --local unzip_to "-d $argv[2]"
  switch $ext
    case tar  # non-compressed, just bundled
      tar -xvf $argv[1] $tar_to
    case xz
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
        tar -axvf $argv[1] $tar_to
      else  # single gzip
        xz -d $argv[1] $tar_to
      end
    case gz
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
        tar -zxvf $argv[1] $tar_to
      else  # single gzip
        gunzip $argv[1] $tar_to
      end
    case tgz  # same as tar.gz
      tar -zxvf $argv[1] $tar_to
    case bz2  # tar compressed with bzip2
      tar -jxvf $argv[1] $tar_to
    case rar
      unrar x $argv[1] $unzip_to
    case zip
      unzip $argv[1] $unzip_to
    case '*'
      echo "unknown extension"
  end
end
