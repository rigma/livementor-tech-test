RSpec.describe LiveMentorTechTest::JsonTranslator do
  it "parses a JSON string" do
    str = <<EOS
[
  {
    "id": 0,
    "email": "colleengriffith@quintity.com",
    "tags": [
      "consectetur",
      "quis"
    ],
    "profiles": {
      "facebook": {
        "id": 0,
        "picture": "//fbcdn.com/a2244bc1-b10c-4d91-9ce8-184337c6b898.jpg"
      },
      "twitter": {
        "id": 0,
        "picture": "//twcdn.com/ad9e8cd3-3133-423e-8bbf-0602e4048c22.jpg"
      }
    }
  },
  {
    "id": 1,
    "email": "maryellengriffin@ginkle.com",
    "tags": [
      "veniam",
      "elit",
      "mollit"
    ],
    "profiles": {
      "facebook": {
        "id": 1,
        "picture": "//fbcdn.com/12e070e0-21ea-4663-97d0-46bc9c7b67a4.jpg"
      },
      "twitter": {
        "id": 1,
        "picture": "//twcdn.com/3057792f-5dfb-4c4b-86b5-cce4d6bbf7ac.jpg"
      }
    }
  }
]
EOS
    translator = LiveMentorTechTest::JsonTranslator.from_str str

    expect(translator.doc.class).to be Array
    expect(translator.doc[0].class).to be Hash
  end

  it "parses a JSON file" do
    translator = LiveMentorTechTest::JsonTranslator.from_file File.dirname(__FILE__) + "/json_example.json"

    expect(translator.doc.class).to be Array
    expect(translator.doc[0].class).to be Hash
    expect(translator.doc[0]["id"]).to eq(0)
  end

  it "raises an exception when an integer is given" do
    expect {
      LiveMentorTechTest::JsonTranslator.from_str "42"
    }.to raise_error LiveMentorTechTest::Error
  end

  it "raises an exception when a float is given" do
    expect {
      LiveMentorTechTest::JsonTranslator.from_str "1.618"
    }.to raise_error LiveMentorTechTest::Error
  end

  it "raises an exception when a string is given" do
    expect {
      LiveMentorTechTest::JsonTranslator.from_str '"Hello, world!"'
    }.to raise_error LiveMentorTechTest::Error
  end
end
