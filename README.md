# DcTarget


事前準備
Deploymentcenterサーバーを起動。接続確認。
ホストPCから、DeploymentcenterサーバーのRepositoryへのアクセス確認。

①任意のJavaをインストール
②DeploymentcenterサーバーのRepository\Setup.zipを任意の場所に展開
③InitTcDeployを実行
④CreateDcEnvを実行（ZドライブにDCサーバーのRepositoryが割り当てられる）
⑤展開されたファイルをZドライブから見つけて任意の場所に展開
⑥deploy.bat -dcusername=dcadmin -dcpassword=dcadmin -softwareLocation=Z:\software

test