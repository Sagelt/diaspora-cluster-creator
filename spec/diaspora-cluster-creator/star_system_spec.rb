require_relative '../spec_helper_lite'
require 'star_system'

describe StarSystem do
  subject { StarSystem.new( Object.new ) }

  def with_loaded_dice(roll, object = subject)
    loaded_dice = MiniTest::Mock.new
    loaded_dice.expect(:roll, roll)
    object.dice = loaded_dice
    yield
    loaded_dice.verify
  end
  
  describe '#technology=' do
    it 'should be overridable' do
      subject.technology = 3
      subject.technology.must_equal 3
    end
  end
  
  describe '#technology' do
    it 'should be randomly rolled' do
      with_loaded_dice(1) do
        subject.technology.must_equal 1
      end
    end
  end

  describe '#resource' do
    it 'should be randomly rolled' do
      with_loaded_dice(1) do
        subject.resource.must_equal 1
      end
    end
  end

  describe '#environment' do
    it 'should be randomly rolled' do
      with_loaded_dice(1) do
        subject.environment.must_equal 1
      end
    end
  end
  
  describe '#<=>' do
    it 'should be comparable to another star system' do
      @system_a = StarSystem.new('')
      @system_b = StarSystem.new('')
      with_loaded_dice(2, @system_a) do
        with_loaded_dice(1, @system_b) do
          @system_b.must_be :<, @system_a
        end
      end
    end
  end
  
  describe '.guarantee!' do
    it 'should adjust technology rating without altering the sort order' do
      @system_a = StarSystem.new('')
      @system_b = StarSystem.new('')
      @system_c = StarSystem.new('')
      order = 
      with_loaded_dice(1, @system_a) do
        with_loaded_dice(0, @system_b) do
          with_loaded_dice(-1, @system_c) do
            input = [@system_b, @system_c, @system_a]
            StarSystem.guarantee!(input).must_equal input
          end
        end
      end

      @system_a.technology.must_equal 2
      @system_b.technology.must_equal 0
      @system_c.technology.must_equal 2
    end

    it 'should not adjust technology rating if one is already adequate' do
      @system_a = StarSystem.new('')
      @system_b = StarSystem.new('')
      @system_c = StarSystem.new('')
      order = 
      with_loaded_dice(2, @system_a) do
        with_loaded_dice(0, @system_b) do
          with_loaded_dice(-1, @system_c) do
            input = [@system_b, @system_c, @system_a]
            StarSystem.guarantee!(input).must_equal input
          end
        end
      end

      @system_a.technology.must_equal 2
      @system_b.technology.must_equal 0
      @system_c.technology.must_equal -1
    end
  end
end
