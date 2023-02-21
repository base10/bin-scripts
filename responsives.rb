#!/usr/bin/env ruby

require "bundler/setup"
require "debug"
require "exif"
require "forwardable"
require "image_processing/vips"
require "image_size"
require "optparse"

class ResponsiveImage

  DEFAULT_QUALITY = 85

  attr_reader(
    :height, :max_dimension, :original, :output_image, :output_dir, :width
  )

  def initialize(max_dimension:, original:, output_dir:)
    @max_dimension = max_dimension
    @original = original
    @output_dir = output_dir
  end

  def process
    # create the variant
    # pass the args to the image processor
    @output_image = ImageProcessing::Vips
      .source(original.path)
      .resize_to_limit(max_dimension, max_dimension)
      .call(save: false)

    @output_image.write_to_file(output_file.to_s, **options)
  end

  def options
    {
      Q: DEFAULT_QUALITY
    }
  end

  def output_file
    Pathname.new(output_dir).join(filename)
  end

  def filename
    [
      original.basename,
      max_dimension
    ].join("_").concat(original.extension)
  end
end

class OriginalImage
  extend Forwardable

  attr_reader :exif, :image_size, :path, :vips_object

  def_delegators :@image_size, :height, :width

  def initialize(input_file:)
    @path = input_file

    @exif = Exif::Data.new(File.open(path))
    @image_size = ImageSize.path(path)
    @vips_object = ImageProcessing::Vips.source(path)
  end

  def orientation
    if height < width
      'landscape'
    elsif height > width
      'portrait'
    else
      'square'
    end
  end

  def basename
    File.basename(path, extension)
  end

  def extension
    File.extname(path)
  end
end

class ResponsiveImageSet
  include Enumerable

  attr_reader :images, :input_file, :original_image, :output_dir

  def initialize(input_file:, output_dir:)
    @input_file = input_file
    @output_dir = output_dir
    @images = []
  end

  def prepare
    @original_image = OriginalImage.new(input_file: input_file)

    variants.each do |variant|
      images << ResponsiveImage.new(
        max_dimension: variant,
        original: original_image,
        output_dir: output_dir
      )
    end
  end

  def each(&block)
    images.each(&block)
  end

  # Assuming for now these would be max for both height and width
  # I probably can't support an infinitely tall monitor, though
  def variants
    [
      1200,
      800,
      640,
      320
    ]
  end
end

class ResponsiveImageBuilder
  attr_reader :input_dir, :input_files, :output_dir

  def initialize(input_dir:, input_files:, output_dir:)
    @input_dir = input_dir
    @input_files = input_files
    @output_dir = output_dir
  end

  def call
    # init the responsive image set
      # Unsure about where the load ought to be carried for what the responsive
      # versions are, starting with ResponsiveImageSet

    input_file = input_file_path(input_files[0])
    image_set = ResponsiveImageSet.new(
      input_file: input_file,
      output_dir: output_dir
    )

    image_set.prepare
    image_set.map(&:process)
  end

  private

  def input_file_path(input_file)
    Pathname.new(input_dir).join(input_file)
  end
end

options = {}
OptionParser.new do |parser|
  parser.banner = "Usage: responsives.rb [options]"

  parser.on(
    "-iINPUT",
    "--input_dir=INPUT",
    String,
    "Directory the source images are from"
  ) do |input_dir|
    options[:input_dir] = input_dir
  end

  parser.on(
    "-fFILES",
    "--input_files=FILES",
    Array,
    "File(s) to act on for input"
  ) do |input_files|
    options[:input_files] = Array(input_files)
  end

  parser.on(
    "-oOUTPUT",
    "--output_dir=OUTPUT",
    String,
    "Directory to output processed responsive images to"
  ) do |output_dir|
    options[:output_dir] = output_dir
  end

  parser.on("-h", "--help", "Prints this help") do
    puts parser
    exit
  end
end.parse!

builder = ResponsiveImageBuilder.new(
  input_dir: options[:input_dir],
  input_files: options[:input_files],
  output_dir: options[:output_dir]
)

builder.call
