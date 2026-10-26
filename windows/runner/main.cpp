#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <fstream>
#include <string>
#include <shlobj.h>
#include <algorithm>
#include <iostream>
#include <cstdio>
#include <exception>
#include <iostream>

#include "flutter_window.h"
#include "utils.h"
#include "flat_json_parser.h"

std::wstring GetAppDataPath() {
  wchar_t path[MAX_PATH];
  if (SUCCEEDED(SHGetFolderPathW(NULL, CSIDL_APPDATA, NULL, 0, path))) {
    return std::wstring(path);
  }
  return L"";
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");
  std::vector<std::string> command_line_arguments = GetCommandLineArguments();
  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  int width = 1280;
  int height = 900;
  int posX = -1;
  int posY = -1;
  try {
    std::wstring appData = GetAppDataPath() + L"\\com.secondstream\\den_ai\\shared_preferences.json";
    std::ifstream file(appData);
    
    if (file.is_open()) {

      std::string jsonContent((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
      file.close();
      if (!jsonContent.empty()) {
        FlatJsonParser parser(jsonContent);
        std::map<std::string, std::string> data = parser.parse();
        if (data.count("flutter.window_width")) {
          width = std::stoi(data["flutter.window_width"]);
        }
        if (data.count("flutter.window_height")) {
          height = std::stoi(data["flutter.window_height"]);
        }
        if (data.count("flutter.window_x")) {
          posX = std::stoi(data["flutter.window_x"]);
        }
        if (data.count("flutter.window_y")) {
          posY = std::stoi(data["flutter.window_y"]);
        }
      }
    }
  } catch (const std::exception& e) {
    std::cerr << "error:" << e.what() << std::endl;
  }
  catch (...) {
    std::cerr << "unknown error " << std::endl;
  }

  if (posX == -1 || posY == -1) {
    posX = (GetSystemMetrics(SM_CXSCREEN) - width) / 2;
    posY = (GetSystemMetrics(SM_CYSCREEN) - height) / 2;
  }

  FlutterWindow window(project);
  Win32Window::Point origin(posX, posY);
  Win32Window::Size size(width, height);
  if (!window.Create(L"DenAI", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);
  
  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}