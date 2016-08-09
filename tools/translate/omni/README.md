A *line* is an object that contains the following properties:
  `bytes`: A UInt8Array containing the original source bytes.
  `source`: A string containing the source text.
  `translation`: A string containing the translated text. 
  `comment`: A string containing any additional comments.

A *section* is an array of lines with an additional `name` property

A *script* is an array of sections along with the additional properties:
  `binary_format`: A string specifying the format used to export the binary.
