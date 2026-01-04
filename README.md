# このリポジトリについて
Wazuhの使い方の備忘録

# Wazuhとは
SIEM（セキュリティ情報イベント管理）とXDR（拡張検知と対応）の機能を統合した、オープンソースの包括的なサイバーセキュリティプラットフォーム。

# wazuh-start.sh
このシェルスクリプトはwazuhサービスを起動する。root権限が必要。
```bash
# パスの通し方
sudo mv wazuh-start.sh /usr/local/bin/
sudo chown root:root /usr/local/bin/wazuh-start.sh
sudo chmod +x /usr/local/bin/wazuh-start.sh
```

# 免責事項
本リポジトリに掲載されている情報は、情報セキュリティの教育および学習、並びに正当な防御手法の向上を目的としています。
掲載された手法を許可されていない対象に対して実行することは違法であり、刑事罰の対象となる可能性があります。本リポジトリの内容を悪用したことにより生じたいかなる損害についても、製作者は一切の責任を負いません。
攻撃手法の理解は、より強固なセキュリティを構築するための第一歩であることを忘れないでください。

# Disclaimer
This repository is for educational and ethical security testing purposes only.
Usage of the tools or techniques provided in this repository for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state, and federal laws.
The author assumes no liability and is not responsible for any misuse or damage caused by this information.
