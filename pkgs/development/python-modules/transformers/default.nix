{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
# propagated build inputs
, filelock
, huggingface-hub
, numpy
, protobuf
, packaging
, pyyaml
, regex
, requests
, tokenizers
, safetensors
, tqdm
# optional dependencies
, scikit-learn
, tensorflow
, torch
, accelerate
, faiss
, datasets
, jax
, jaxlib
, flax
, optax
, ftfy
, onnxruntime
, cookiecutter
, sagemaker
, fairscale
, optuna
, ray
, pydantic
, uvicorn
, fastapi
, starlette
, librosa
, phonemizer
, torchaudio
, pillow
, timm
, torchvision
, av
, sentencepiece
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.30.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-S1jQsBObKGZY9tlbcNcgchwUs/eeaohYxOtbN1cPa2Q=";
  };

  propagatedBuildInputs = [
    filelock
    huggingface-hub
    numpy
    protobuf
    packaging
    pyyaml
    regex
    requests
    tokenizers
    safetensors
    tqdm
  ];

  passthru.optional-dependencies =
  let
    audio = [
      librosa
      # pyctcdecode
      phonemizer
      # kenlm
    ];
    vision = [ pillow ];
  in
    {
    ja = [
      # fugashi
      # ipadic
      # unidic_lite
      # unidic
    ];
    sklearn = [
      scikit-learn
    ];
    tf = [
      tensorflow
      # onnxconverter-common
      # tf2onnx
      # tensorflow-text
      # keras-nlp
    ];
    torch = [
      torch
      accelerate
    ];
    retrieval = [ faiss datasets ];
    flax = [ jax jaxlib flax optax ];
    tokenizers = [
      tokenizers
    ];
    ftfy = [ ftfy ];
    onnxruntime = [
      onnxruntime
      # onnxruntime-tools
    ];
    onnx = [
      # onnxconverter-common
      # tf2onnx
      onnxruntime
    ];
    modelcreation = [
      cookiecutter
    ];
    sagemaker = [
      sagemaker
    ];
    deepspeed = [
      # deepspeed
      accelerate
    ];
    fairscale = [ fairscale ];
    optuna = [ optuna ];
    ray = [ ray ] ++ ray.optional-dependencies.tune-deps;
    # sigopt = [ sigopt ];
    # integrations = ray ++ optuna ++ sigopt;
    serving = [
      pydantic
      uvicorn
      fastapi
      starlette
    ];
    audio = audio;
    speech = [ torchaudio ] ++ audio;
    torch-speech = [ torchaudio ] ++ audio;
    tf-speech = audio;
    flax-speech = audio;
    timm = [ timm ];
    torch-vision = [ torchvision ] ++ vision;
    # natten = [ natten ];
    # codecarbon = [ codecarbon ];
    video = [
      # decord
      av
    ];
    sentencepiece = [ sentencepiece protobuf ];
  };


  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [
    "transformers"
  ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/transformers";
    description = "Natural Language Processing for TensorFlow 2.0 and PyTorch";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pashashocky happysalada ];
  };
}
