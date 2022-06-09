import 'dart:io';
import 'package:flutter/material.dart';
import 'package:picture_ml/app/home/home_controller.dart';

class HomePage extends StatelessWidget {
  final controller = HomeController();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reconhecedor de Imagens"),
      ),
      body: AnimatedBuilder(
        animation: controller.notifierImage,
        builder: (_, child) {
          if (controller.imagePath == null) return buildSelectImage();

          return buildSelectedImage(context);
        },
      ),
    );
  }

  Widget buildSelectImage() {
    return Center(
      child: ElevatedButton(
        child: const Text("Selecionar imagem"),
        onPressed: controller.selectImage,
      ),
    );
  }

  Widget buildSelectedImage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(
            File(controller.imagePath!),
            width: 200,
          ),
          ElevatedButton(
            child: const Text("Analisar imagem"),
            onPressed: () {
              showModal(context);
              controller.recognizeImage();
            },
          ),
          ElevatedButton(
            child: const Text("Voltar"),
            onPressed: controller.deleteImage,
          ),
        ],
      ),
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Analisando imagem"),
          content: AnimatedBuilder(
            animation: controller.notifierState,
            builder: (_, child) {
              if (controller.state == ViewState.loading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 30,
                      height: 30,
                    ),
                  ],
                );
              }

              if (controller.state == ViewState.error) {
                return const Text("Ocorreu um erro ao analisar.");
              }

              return Text(
                  "Resultado da análise: ${controller.recognizedImage}");
            },
          ),
          actions: [
            TextButton(
              child: const Text("Voltar"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
