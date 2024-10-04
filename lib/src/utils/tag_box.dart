import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TextTag extends StatelessWidget {
  const TextTag({
    super.key,
    required this.stringTagController,
    required this.distanceToField,
  });

  final StringTagController<String> stringTagController;
  final double distanceToField;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags<String>(
      textfieldTagsController: stringTagController,
      initialTags: [],
      textSeparators: const [' ', ','],
      validator: (String tag) {
        if (stringTagController.getTags!.contains(tag)) {
          return 'You\'ve already entered that';
        }
        if (stringTagController.getTags!.length >= 5) {
          return 'Only 5 tags are allowed';
        }
        return null;
      },
      inputFieldBuilder: (context, inputFieldValues) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onTap: () {
              stringTagController.getFocusNode?.requestFocus();
            },
            controller: inputFieldValues.textEditingController,
            focusNode: inputFieldValues.focusNode,
            decoration: InputDecoration(
              isDense: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 171, 113, 243),
                  width: 3.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 146, 90, 214),
                  width: 3.0,
                ),
              ),
              helperStyle: const TextStyle(
                color: Color.fromARGB(255, 146, 90, 214),
              ),
              hintText: inputFieldValues.tags.isNotEmpty ? '' : "Enter tag...",
              errorText: inputFieldValues.error,
              prefixIconConstraints:
                  BoxConstraints(maxWidth: distanceToField * 0.8),
              prefixIcon: inputFieldValues.tags.isNotEmpty
                  ? SingleChildScrollView(
                      controller: inputFieldValues.tagScrollController,
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: 8,
                        ),
                        child: Wrap(
                            runSpacing: 4.0,
                            spacing: 4.0,
                            children: inputFieldValues.tags.map((String tag) {
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: Color.fromARGB(255, 146, 90, 214),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        '#$tag',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        //print("$tag selected");
                                      },
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 14.0,
                                        color:
                                            Color.fromARGB(255, 233, 233, 233),
                                      ),
                                      onTap: () {
                                        inputFieldValues.onTagRemoved(tag);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                      ),
                    )
                  : null,
            ),
            onChanged: inputFieldValues.onTagChanged,
            onSubmitted: inputFieldValues.onTagSubmitted,
          ),
        );
      },
    );
  }
}
