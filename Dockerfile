FROM python:3.12.9-slim-bookworm

# 作業ディレクトリの設定
WORKDIR /usr/src/app

# 依存関係ファイルをコピーしてインストール
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# spaCyの英語モデルをダウンロード
RUN python -m spacy download en_core_web_sm

# アプリケーションのソースコードをコピー
COPY . .

# Cloud Run用のCMD
# Cloud Runでは環境変数PORTで指定されたポートでの待受が必要
CMD ["sh", "-c", "exec uvicorn app:app --host 0.0.0.0 --port ${PORT:-8080}"]
