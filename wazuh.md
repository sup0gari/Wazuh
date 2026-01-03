# Wazuhとは
SIEM（セキュリティ情報イベント管理）とXDR（拡張検知と対応）の機能を統合した、オープンソースの包括的なサイバーセキュリティプラットフォーム。

## ossec.conf
どのログをWazuhマネージャーに送るか決めるファイル  
`C:\Program Files (x86)\ossec-agent\ossec.conf`

## ホワイトリスト登録
```xml
<!-- /var/ossec/etc/rules/local_rules.xml -->
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
