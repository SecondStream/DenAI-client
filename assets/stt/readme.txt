You need to place the following files in this directory:
decoder.onnx
encoder.onnx
joiner.onnx
model.onnx
tokens.txt
vad.onnx
These can be downloaded from the sherpa-onnx repository:
https://github.com/k2-fsa/sherpa-onnx/releases/tag/asr-models

The project uses:
sherpa-onnx-nemo-fast-conformer-transducer-be-de-en-es-fr-hr-it-pl-ru-uk-20k-int8 (a non-int8-quantized version will, of course, also work—and potentially even perform better—but it will have a larger file size)
and
silero_vad.onnx