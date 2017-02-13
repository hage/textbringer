# frozen_string_literal: true

require "curses"

module Textbringer
  class Face
    attr_reader :name, :attributes

    @@face_table = {}
    @@next_color_pair = 1

    STANDARD_COLORS = {
      "default" => -1,
      "black" => Curses::COLOR_BLACK,
      "red" => Curses::COLOR_RED,
      "green" => Curses::COLOR_GREEN,
      "yellow" => Curses::COLOR_YELLOW,
      "blue" => Curses::COLOR_BLUE,
      "magenta" => Curses::COLOR_MAGENTA,
      "cyan" => Curses::COLOR_CYAN,
      "white" => Curses::COLOR_WHITE
    }

    def self.[](name)
      @@face_table[name]
    end

    def self.define(name, **opts)
      if @@face_table.key?(name)
        @@face_table[name].update(**opts)
      else
        @@face_table[name] = new(name, **opts)
      end
    end

    def initialize(name, **opts)
      @name = name
      @color_pair = @@next_color_pair
      @@next_color_pair += 1
      update(**opts)
    end

    def update(foreground: -1, background: -1,
               bold: false, italic: false, underline: false)
      @foreground = foreground
      @background = background
      @bold = bold
      @italic = italic
      @underline = underline
      Curses.init_pair(@color_pair,
                       color_value(foreground), color_value(background))
      @attributes = 0
      @attributes |= Curses.color_pair(@color_pair)
      @attributes |= Curses::A_BOLD if bold
      @attributes |= Curses::A_ITALIC if italic
      @attributes |= Curses::A_UNDERLINE if underline
    end

    private

    def color_value(color)
      STANDARD_COLORS[color] || color
    end
  end
end