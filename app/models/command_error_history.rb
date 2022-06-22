class CommandErrorHistory < ApplicationRecord
  enum :command, {
    wear: 0
  }
end
