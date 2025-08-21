class MarkdownUtils {
  static final MarkdownUtils _instance = MarkdownUtils._internal();
  
  final RegExp htmlTags = RegExp(r'<[^>]+>');
  final RegExp boldMarkdown = RegExp(r'\*\*(.*?)\*\*');
  final RegExp italicMarkdown = RegExp(r'\*(.*?)\*');
  final RegExp codeMarkdown = RegExp(r'`(.*?)`');
  final RegExp headersMarkdown = RegExp(r'#+ ');
  final RegExp listMarkers = RegExp(r'\n\s*[\*\-\+]\s+');
  final RegExp numberedLists = RegExp(r'(\n|^)\s*(\d+)\.\s+');
  
  factory MarkdownUtils() {
    return _instance;
  }
  
  MarkdownUtils._internal();
  
  String stripMarkdownAndHtml(String text) {  
    String cleanedText = text
      .replaceAll(htmlTags, '')
      .replaceAllMapped(boldMarkdown, (match) => match.group(1) ?? '')
      .replaceAllMapped(italicMarkdown, (match) => match.group(1) ?? '')
      .replaceAllMapped(codeMarkdown, (match) => match.group(1) ?? '')
      .replaceAll(headersMarkdown, '')
      .replaceAll(listMarkers, '\n- ')
      .trim();
    
    
    return _fixNumberedLists(cleanedText);
  }
  
  String _fixNumberedLists(String text) {
    final lines = text.split('\n');
    final result = <String>[];
    int listCounter = 1;
    bool inNumberedList = false;
    
    for (String line in lines) {
      final match = numberedLists.firstMatch(line);      
      
      if (match != null) {
        if (!inNumberedList) {
          inNumberedList = true;
          listCounter = 1;
        }
        
        final content = line.substring(match.end);

        result.add('$listCounter. $content');
        listCounter++;
      } else {
        inNumberedList = false;
        result.add(line);
      }
    }
    
    return result.join('\n');
  }
  
  String textToHtml(String text) {
    return text
      .replaceAll('\n', '<br>')
      .replaceAll('  ', '&nbsp;&nbsp;');
  }
}