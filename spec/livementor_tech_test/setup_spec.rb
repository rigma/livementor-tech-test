RSpec.describe LiveMentorTechTest do
  it "parses a JSON representation into a CSV one" do
    csv = LiveMentorTechTest::json2csv '[{"a":1,"b":2,"c":{"d":["hello", "world"],"e":{"f":3,"g":4.1}}}]'

    expect(csv).to eq(%{a,b,c.d,c.e.f,c.e.g
1,2,"hello,world",3,4.1
})
  end

  it "converts a JSON file into a CSV one" do
    LiveMentorTechTest::fjson2csv File.dirname(__FILE__) + "/json_example.json", File.dirname(__FILE__) + "/output.csv"

    expect(File.read(File.dirname(__FILE__) + "/output.csv")).to eq(File.read(File.dirname(__FILE__) + "/csv_example.csv"))
    File.unlink File.dirname(__FILE__) + "/output.csv"
  end
end
