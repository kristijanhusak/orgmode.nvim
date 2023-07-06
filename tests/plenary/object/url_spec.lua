local Url = require('orgmode.objects.url')
describe('Url', function()
  it('should detect dedicated target for internal links', function()
    local anchor_examples = {
      'some anchor',
      'x',
      '_12 ABC',
      '123-456-2342',
    }
    for _, url_str in ipairs(anchor_examples) do
      local url = Url.new(url_str)
      local anchor = url:get_dedicated_target()
      assert(anchor == url_str, string.format('Expected %q, actual %q', url_str, anchor))
    end
  end)

  it('should detect a headline within a file url', function()
    local headline_examples = {
      {
        'file:./../parent_path/sibling_folder/somefile.org::*some headline',
        './../parent_path/sibling_folder/somefile.org',
        'some headline',
      },
    }
    for _, item in ipairs(headline_examples) do
      local input, expected_file, expected_hl = item[1], item[2], item[3]
      local url = Url.new(input)
      local filepath = url:get_filepath()
      local headline = url:get_headline()
      assert(url:is_file_headline(), "Expect to be a file with headline, but isn't")
      assert(filepath == expected_file, string.format('Expected %q, actual %q', expected_file, filepath))
      assert(headline == expected_hl, string.format('Expected %q, actual %q', expected_hl, headline))
    end
  end)

  it('should not detect too funky characters', function()
    local anchor_examples = {
      'a != b',
      '!bang',
      'a/file/path',
      '#custom_id',
      '*headline',
    }
    for _, url_str in ipairs(anchor_examples) do
      local url = Url.new(url_str)
      local anchor = url:get_dedicated_target()
      assert(anchor == nil, string.format('Expected %q to be resolved to nil, actual %q', url_str, anchor))
    end
  end)
end)