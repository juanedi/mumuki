class Submission < ActiveRecord::Base
  include Compilation
  include TestRunning
  include WithStatus

  belongs_to :exercise
  belongs_to :submitter, class_name: 'User'

  validates_presence_of :exercise, :submitter

  after_create :update_submissions_count!
  after_commit :schedule_test_run!, on: :create

  delegate :language, :plugin, :title, to: :exercise

  private

  def update_submissions_count!
    self.class.connection.execute(
        "update exercises
         set submissions_count = submissions_count + 1
        where id = #{exercise.id}")
    exercise.reload
  end
end



