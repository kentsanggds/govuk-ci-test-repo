require "test_helper"

describe DitLandingPageController do
  include DitLandingPageHelpers

  before do
    stub_all_eubusiness_pages
  end

  describe "GET show" do
    expected_content = {
      de: "Informationen für Unternehmen mit Sitz in der EU, die Handelsbeziehungen mit dem Vereinigten Königreich unterhalten",
      es: "Comerciar con el Reino Unido como empresa con sede en la UE",
      fr: "Travailler avec le Royaume-Uni à partir du 1er janvier 2021 en tant qu'entreprise basée dans l'UE",
      it: "Se la tua azienda ha sede nell’UE, scopri le nuove regole per continuare a fare affari con il Regno Unito dal 1° gennaio 2021",
      nl: "Handel drijven met het Verenigd Koninkrijk vanuit een in de EU gevestigde onderneming vanaf 1 januari 2021",
      pl: "Handel z Wielką Brytanią od 1 stycznia 2021 roku – informacje dla firm z Unii Europejskiej",
    }

    expected_content.each_key do |locale|
      it "renders translated page for the #{locale} locale" do
        get :show, params: { locale: locale }
        assert_response :success
        assert_select "h1", expected_content[locale]
        assert_select "main[lang=#{locale}]"
      end
    end

    it "renders the English page" do
      get :show
      assert_response :success
      assert_select "h1", I18n.t!("dit_landing_page.page_header")
      assert_select "main[lang=en]", false
    end
  end
end
