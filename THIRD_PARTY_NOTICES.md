# Third-Party Notices & Model Licenses

The source code of this application is licensed under the **GNU General Public License v3.0 (GPLv3)** (see the root `LICENSE` file).

This project uses and/or provides instructions for obtaining third-party runtime libraries and pre-trained machine learning model weights. These components and model weights are separate works and remain governed by their respective original licenses listed below, rather than GPLv3.

---

## 1. Runtime Libraries

### sherpa-onnx
- **Source:** https://github.com/k2-fsa/sherpa-onnx
- **Copyright:** Copyright (c) 2022-present Xiaomi Corporation / k2-fsa Contributors
- **License:** Apache License 2.0 (https://apache.org)
- **Notes:** Used for local on-device speech inference. Prebuilt native binaries of `sherpa-onnx` also bundle **ONNX Runtime** (Copyright (c) Microsoft Corporation, licensed under the MIT License).

---

## 2. Pre-trained Model Weights

### Silero VAD
- **Source:** https://github.com/snakers4/silero-vad
- **Copyright:** Copyright (c) 2020-present Silero Team
- **License:** MIT License

```text
MIT License

Copyright (c) 2020-present Silero Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

### NVIDIA FastConformer-Transducer Large (Multilingual ASR)
- **Model:** `nvidia/stt_be_de_en_es_fr_hr_it_pl_ru_uk_fastconformer_transducer_large`
- **Source:** https://huggingface.co
- **Author:** NVIDIA Corporation
- **License:** Creative Commons Attribution 4.0 International (CC BY 4.0) (https://creativecommons.org)
- **Modifications:** Converted/exported to ONNX format for local inference via `sherpa-onnx` (if applicable).

---

### Supertone Supertonic-3 (Multilingual TTS)
- **Model:** `Supertone/supertonic-3`
- **Source:** https://huggingface.co/Supertone/supertonic-3
- **Author:** Supertone Inc.
- **License:** BigScience Open RAIL-M License (https://huggingface.co/Supertone/supertonic-3/blob/main/LICENSE)
- **Notes:** Model weights are governed by the BigScience Open RAIL-M License, including its Attachment A (Use Restrictions). Any redistribution or downstream use of these model weights must comply with the terms and use-based restrictions of the Open RAIL-M License.
