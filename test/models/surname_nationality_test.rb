require "test_helper"

class SurnameNationalityTest < ActiveSupport::TestCase
  test 'should have columns' do 
    assert SurnameNationality.column_names.include?('surname_id')
    assert SurnameNationality.column_names.include?('surname_name')
    assert SurnameNationality.column_names.include?('nationality_id')
    assert SurnameNationality.column_names.include?('nationality_name')
  end

  test 'should validate associations' do 
    first_entry = SurnameNationality.new(
      surname_name: Faker::Name.last_name, 
      nationality_id: nationalities(:one).id, 
      nationality_name: Faker::Nation.nationality
    ) 
    refute first_entry.save
    second_entry = SurnameNationality.new(
      surname_id: surnames(:one).id, 
      surname_name: Faker::Name.last_name, 
      nationality_name: Faker::Nation.nationality
    )
    refute second_entry.save
  end 

  test 'should validate surname_name' do 
    record = SurnameNationality.new(
      surname_id: surnames(:three).id, 
      nationality_id: nationalities(:two).id, 
      nationality_name: Faker::Nation.nationality
    )
    refute record.save
  end 

  test 'should validate nationality_name' do 
    record = SurnameNationality.new(
      surname_id: surnames(:five).id, 
      surname_name: Faker::Name.last_name, 
      nationality_id: nationalities(:three).id 
    )
    refute record.save
  end

  test 'should throw error if parent ids are not unique' do
    error = assert_raises StandardError do 
      duplicate_record.save!
    end
    assert_match /This record already exists./, error.message
  end

  test 'should know parent surname' do 
    assert_equal surname_nationalities(:one).surname, surnames(:one)
  end 

  test 'should know parent nationality' do 
    assert_equal surname_nationalities(:one).nationality, nationalities(:one)
  end

  def duplicate_record 
    SurnameNationality.new(
      surname_id: surnames(:one).id, 
      surname_name: surnames(:one).name, 
      nationality_id: nationalities(:one).id, 
      nationality_name: nationalities(:one).name 
    )
  end
end
