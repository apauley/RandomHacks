class StatsKeeper
  def initialize
    @start_time = Time.now
    @valid_attempts = 0
    @error_attempts = 0
  end

  def valid_attempt!
    @valid_attempts = @valid_attempts + 1
  end

  def error_attempt!
    @error_attempts = @error_attempts + 1
  end

  def end_time!
    @end_time = Time.now
    freeze
  end

  def start_time
    @start_time
  end

  def end_time
    @end_time
  end

  def elapsed_time
    end_time - start_time
  end

  def valid_attempts
    @valid_attempts
  end

  def error_attempts
    @error_attempts
  end

  def total_attempts
    @valid_attempts + @error_attempts
  end
end
