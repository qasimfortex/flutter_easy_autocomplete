// Copyright 2021 4inka

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.

// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.

// 3. Neither the name of the copyright holder nor the names of its contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';

class FilterableList extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTapped;
  final double elevation;
  final double maxListHeight;
  final Decoration? suggestionDecoration;
  final TextStyle suggestionTextStyle;
  final Color? suggestionBackgroundColor;
  final bool loading;
  final Widget Function(String data)? suggestionBuilder;
  final Widget? progressIndicatorBuilder;
  final TextStyle? sortedHeadingsTextStyle;

  const FilterableList(
      {required this.items,
      required this.onItemTapped,
      this.sortedHeadingsTextStyle,
      this.suggestionBuilder,
      this.elevation = 5,
      this.maxListHeight = 150,
      this.suggestionDecoration,
      this.suggestionTextStyle = const TextStyle(),
      this.suggestionBackgroundColor,
      this.loading = false,
      this.progressIndicatorBuilder});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);

    Color _suggestionBackgroundColor = suggestionBackgroundColor ??
        scaffold?.widget.backgroundColor ??
        theme.scaffoldBackgroundColor;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: _suggestionBackgroundColor,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxListHeight),
        decoration: suggestionDecoration,
        child: Visibility(
          visible: items.isNotEmpty || loading,
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(5),
              itemCount: loading ? 1 : items.length,
              itemBuilder: (context, index) {
                if (loading) {
                  return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Visibility(
                          visible: progressIndicatorBuilder != null,
                          replacement: CircularProgressIndicator(),
                          child: progressIndicatorBuilder!));
                }
                String currentItem = items[index];
                bool isHeading = currentItem.length == 1 &&
                    RegExp(r'^[A-Z]$').hasMatch(currentItem);
                if (isHeading) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(12, 5, 5, 5),
                    alignment: Alignment.centerLeft,
                    child: Text(currentItem, style: sortedHeadingsTextStyle),
                  );
                }
                if (suggestionBuilder != null) {
                  return InkWell(
                    child: suggestionBuilder!(currentItem),
                    onTap: () => onItemTapped(currentItem),
                  );
                }
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: Text(currentItem, style: suggestionTextStyle)),
                      onTap: () => onItemTapped(currentItem)),
                );
              }),
        ),
      ),
    );
  }
}
