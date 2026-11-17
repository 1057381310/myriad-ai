# 万象 MyriadAI · 多模态 AI 智能平台

一个**完全本地运行、支持离线部署**的多模态 AI 平台，基于 FastAPI 与 HuggingFace 开源模型构建，覆盖「听、说、看、思、译」全场景，提供 Web 界面与 RESTful API。

## 功能特性

| 功能 | 说明 | 底层模型 |
|---|---|---|
| 智能对话 Chat | 多轮对话与通用问答 | Qwen3-VL-2B-Instruct |
| 文本翻译 Translate | 多语言互译 | Qwen3-VL-2B-Instruct |
| 语音合成 TTS | 文字转语音，支持多种音色 | Kokoro-82M |
| 语音识别 ASR | 音频转文字 | Whisper-large-v3-turbo |
| 文字识别 OCR | 图像文字提取 | Qwen3-VL-2B-Instruct |
| 说话人分离 Diarization | 区分不同说话人并分段 | Pyannote Speech-Diarization-3.0 |
| 会议总结 Summary | 带说话人标签的逐字稿与结构化会议纪要 | Pyannote + Whisper + Qwen |

## 技术栈

- **Web 框架**：FastAPI、Uvicorn
- **推理框架**：PyTorch 2.6（CPU / GPU 均可）、Transformers、Accelerate
- **本地模型**：Qwen3-VL、Whisper、Kokoro、Pyannote、SpeechBrain、ONNX Runtime
- **音频处理**：torchaudio、soundfile、Kokoro + Misaki 中文 G2P
- **图像处理**：Pillow

## 离线与多环境设计

- 所有模型采用 HuggingFace 缓存结构，**强制离线读取**，无需联网即可运行。
- 通过 `PROFILE` 切换运行环境：
  - `local`：Windows / CPU / 懒加载，首次调用时载入模型。
  - `server`：Linux / GPU / 启动即预热并常驻显存。
- 设备、精度、模型目录等差异全部收敛到 `config.py` 与 `.env`，切换环境无需改代码。

## 目录结构

```
万象/
├── routers/               # 各功能 API 路由（tts/asr/chat/ocr 等）
├── services/              # 业务服务与模型封装
├── static/                # 前端页面 myriad-ai.html
├── config.py              # 全局配置、环境变量、离线模型路径解析
├── prompts.py             # 提示词
├── main.py                # FastAPI 入口与模型预热
├── requirements.txt       # CPU 依赖
├── requirements-gpu.txt   # GPU 依赖
├── outputs/               # 运行产物（已忽略）
└── .env.example
```

## 快速开始

### 1. 安装依赖

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
pip install -r requirements.txt
```

### 2. 准备模型

将 HuggingFace 模型缓存放到 `MODEL_DIR` 指定目录，结构为：

```
<MODEL_DIR>/models--<org>--<name>/snapshots/<commit-hash>/
```

### 3. 配置环境变量

```bash
cp .env.example .env
```

### 4. 启动服务

```bash
uvicorn main:app --host 127.0.0.1 --port 8001
```

启动后访问：

- 应用界面：http://127.0.0.1:8001
- 健康检查：http://127.0.0.1:8001/healthz

> 本地默认懒加载，首次调用某个功能时会加载对应模型，请耐心等待。

## 环境变量说明

| 变量 | 说明 |
|---|---|
| `PROFILE` | 运行环境：`local` / `server` |
| `EAGER_LOAD` | 是否启动时一次性加载全部模型 |
| `KEEP_MODELS_RESIDENT` | 模型是否常驻显存 |
| `TORCH_DEVICE` | 推理设备：`cpu` / `cuda` |
| `TORCH_DTYPE` | 推理精度：`float32` / `float16` / `bfloat16` |
| `MODEL_DIR` | 离线模型缓存目录 |
| `HF_TOKEN` | HuggingFace Token（离线已缓存可留空） |

> `.env`、`.env.local`、`.env.server` 等含密钥文件均已通过 `.gitignore` 忽略，不会提交。

## 本地模型清单

- Qwen/Qwen3-VL-2B-Instruct
- openai/whisper-large-v3-turbo
- hexgrad/Kokoro-82M
- pyannote/speaker-diarization-3.0
- pyannote/segmentation-3.0
- hbredin/wespeaker-voxceleb-resnet34-LM

## 安全说明

仓库严格排除环境变量、HF Token、虚拟环境、日志、运行产物与模型缓存；请勿提交包含真实凭据或大体积模型文件的内容。
