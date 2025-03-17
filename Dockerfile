FROM python:3.10-slim

WORKDIR /usr/src/app

# 依存関係ファイルをコピーしてインストール
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# spaCyの英語モデルをダウンロード
RUN python -m spacy download en_core_web_sm

# アプリケーションのソースコードをコピー
COPY . .

# Cloud Run用のエントリーポイント
# Cloud Runは環境変数PORTで待ち受けポートを指定するので、それを直接利用します。
CMD ["sh", "-c", "exec uvicorn app:app --host 0.0.0.0 --port $PORT"]