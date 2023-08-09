// Copyright 2023 mathru. All rights reserved.

/// Plug-in to make OpenAI API available on Masamune Framework. API key registration is required separately.
///
/// To use, import `package:masamune_ai_openai/masamune_ai_openai.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune_ai_openai;

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:dart_openai/dart_openai.dart';
import 'package:masamune/masamune.dart';

export 'package:dart_openai/dart_openai.dart'
    show OpenAIFunctionModel, FunctionCall, FunctionCallResponse;

part 'adapter/openai_masamune_adapter.dart';
part 'functions/openai_chat_gpt_functions_action.dart';

part 'prompt/character_chat_prompt_builder.dart';

part 'src/openai_chat.dart';
part 'src/openai_media.dart';
part 'src/openai_chat_prompt_builder.dart';
