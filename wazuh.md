## 起動コマンド（マネージャー）
```bash
sudo systemctl start wazuh-manager
sudo systemctl start wazuh-indexer
sudo systemctl start wazuh-dashboard
sudo systemctl status wazuh-manager wazuh-indexer wazuh-dashboard # 確認コマンド
```

## 起動コマンド（エージェント）
```powershell
Start-Service -Name Wazuh
Stop-Service -Name Wazuh
Restart-Service -Name Wazuh
Get-Service -Name Wazuh # 確認コマンド
Get-Content "C:\Program Files (x86)\ossec-agent\ossec.log" -Tail 20 # ログから通信状態確認
```

## ossec.conf
どのログをWazuhマネージャーに送るか決めるファイル  
`C:\Program Files (x86)\ossec-agent\ossec.conf`

## 設定ファイルチェック
`/var/ossec/bin/wazuh-analysisd -t`

## JSONのフィールドについて
`data.win.eventdata.image`: 実際に実行されたバイナリのフルパス  
`data.win.eventdata.commandLine` : 実行時の引数（オプション）を含む全コマンド  
`data.win.eventdata.hashes` : ファイルのハッシュ値（SHA256など）  
`data.win.eventdata.integrityLevel` : プロセスの権限レベル（System, High, Mediumなど）  
`data.win.eventdata.parentImage` : このプロセスを起動した「親」のフルパス  
`data.win.eventdata.parentCommandLine` : 親プロセスがどのような引数で実行されていたか  
`data.win.eventdata.user` : 実行したユーザー名  
`data.win.eventdata.currentDirectory` : コマンドが実行されたディレクトリ  
`data.win.system.eventID` : SysmonのイベントID  
`rule.id` : Wazuhがどのルールにヒットさせたかを示すID  
`rule.mitre.id` : MITRE ATT&CK（T1087など）

## ルールのタグについて
```bash
rule: idとlevelを属性として持つ。idは100000~120000がユーザーとして使える。levelは0~15まである。
if_sid: 指定したルールIDが一致した場合のみ評価する。
field: ログ内の特定の項目を検査。type="pcre2"で正規表現使用可。
match: ログメッセージ、または指定フィールド内の文字列検索。
description: アラートのタイトルとして出力。
mitre: TIDとの紐付け。
```

### 設定ファイル
`/var/ossec/etc/rules/local_rules.xml`
```xml
<group name="windows,sysmon,">
  <rule id="100005" level="0"> <!-- 0=検知しない -->
    <if_sid>92039</if_sid> 
    <field name="win.eventdata.user">administrator</field>
    <field name="win.eventdata.image">cmd.exe</field>
    <description>アラートタイトル</description>
  </rule>
</group>
```

## ログテスト
`/var/ossec/bin/wazuh-logtest`
