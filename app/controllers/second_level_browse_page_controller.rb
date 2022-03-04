class SecondLevelBrowsePageController < ApplicationController
  include RecruitmentBannerHelper
  enable_request_formats show: [:json]

  def show
    setup_content_item_and_navigation_helpers(page)

    if show_banner?(request.path)
      @show_recruitment_banner = true
      @study_url = study_url_for(request.path)
    end

    respond_to do |f|
      f.html do
        show_html
      end
      f.json do
        render json: {
          content_id: page.content_id,
          navigation_page_type: "Second Level Browse",
          breadcrumbs: breadcrumb_content,
          html: render_partial("_links", page: page),
        }
      end
    end
  end

private

  def show_html
    render :show,
           locals: {
             page: page,
             meta_section: meta_section,
           }
  end

  def meta_section
    page.active_top_level_browse_page.title.downcase
  end

  def page
    @page ||= MainstreamBrowsePage.find(
      "/browse/#{params[:top_level_slug]}/#{params[:second_level_slug]}",
    )
  end
end
