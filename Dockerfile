FROM python:3.10-slim

WORKDIR /usr/src/app

# 依存関係ファイルをコピーしてインストール
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# spaCyの英語モデルをダウンロード
RUN python -m spacy download en_core_web_sm

# アプリケーションのソースコードをコピー
COPY . .

# Cloud Run向けエントリーポイント（環境変数 PORT を利用）
CMD ["sh", "-c", "exec uvicorn main:app --host 0.0.0.0 --port $PORT"]