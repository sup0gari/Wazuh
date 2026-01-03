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

## ホワイトリスト登録
```xml
<!-- /var/ossec/etc/rules/local_rules.xml -->
<!-- type="pcre2" これで正規表現使用可 -->
<group name="windows,sysmon,">
  <rule id="100005" level="0"> <!-- 0=検知しない -->
    <if_sid>92039</if_sid> 
    <field name="win.eventdata.user">ユーザー</field>
    <field name="win.eventdata.image">コマンド</field>
    <description>Whitelist: 任意</description>
  </rule>
</group>
```

## 自作のIoC登録
下記のパスにIoCファイルを作成  
`/var/ossec/etc/lists/`  
下記のファイルに作成したファイルを登録  
`/var/ossec/etc/ossec.conf`
```conf
<ruleset>
  <list>etc/lists/<ファイル名></list>
</ruleset>
```
検知ルールの作成  
```xml
<!-- /var/ossec/etc/rules/local_rules.xml -->
<group name="sysmon,ioc_detection,">
  <rule id="100001" level="10"> <!-- 自作は100000台 -->
    <if_sid>61603</if_sid> <list field="win.eventdata.destinationIp" lookup="address_match_key">etc/lists/blacklist-ips</list>
    <description>IoC Detection: </description>
    <mitre>
      <id>T1071</id> </mitre>
  </rule>
</group>
```
再起動  
`sudo systemctl restart wazuh-manager`
