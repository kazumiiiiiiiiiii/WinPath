# WinPath
-
### 用途

Windows用の（「\」が含まれる）パスをMac用の（「/」に変換した）パスに変換し、Finderを開きます。

「//」から始まるパスの場合は、「smb」「afp」で接続します。

### カスタマイズ

パスを追加で変換したい場合は、PathManager.swiftで変換できます。

[PathManager.swift](https://github.com/kazumiiiiiiiiiii/WinPath/blob/master/WinPath/Classes/PathManager.swift)

### インストール方法

-  wgetコマンドで「Installer」ディレクトリあるインストール用のdmgファイルをダウンロード。
- WinPath.dmgを開いて、「Application」ディレクトリにコピーしてください。

```
wget https://github.com/kazumiiiiiiiiiii/WinPath/blob/master/Installer/WinPath.dmg
```
