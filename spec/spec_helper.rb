# encoding: UTF-8

def spec_test_dir(spec_filename)
  dir, file = File.split(spec_filename)
  basename = File.basename(file, File.extname(file))
  File.join(dir, "#{basename}_data")
end
