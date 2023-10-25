class Document
  def initialize(path:, parser:)
    @path = path
    @parser_service = parser.new(@path)
  end

  def parse
    @parser_service.parse
  end
end

class BaseDocumentParser
  def initialize(path:)
    @path = path
  end
end

class PdfDocumentParser < BaseDocumentParser
  def parse
    # code
  end
end

class DocxDocumentParser < BaseDocumentParser
  def parse
    # code
  end
end

class OdfDocumentParser < BaseDocumentParser
  def parse
    # code
  end
end
