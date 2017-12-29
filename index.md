---
layout: default
---

<div class="home">
	<div class="container-fluid">
		<div class="row no-gutters top">

			<div class="col-md-4 offset-md-1">
				<div class="description">
					Polypay sheep were developed in the United States with the goal of developing a breed of sheep known for its maternal characteristics including early fertility, prolificacy, aseasonal breeding, and milk production. These qualities make them an excellent foundation for many production systems.
				</div>
				<div class="purpose">
					The purpose of the American Polypay Sheep Association is to engage in the promotion, advancement, and continued improvement of the Polypay breed of sheep throughout the world.
				</div>
			</div>


			<div class="col-md-6">
				{% assign reverse_photos = site.photo_gallery | reverse %}
				{% assign first_pic = false %}

				<div id="photo-carousel" class="carousel slide" data-interval="3000" data-ride="carousel">
				  <div class="carousel-inner" role="listbox">

						{% for photo in reverse_photos %}
							{% if photo.img_file %}
								{% if first_pic == false %}
									<div class="carousel-item active">
									{% assign first_pic = true %}
								{% elsif photo.img_file != reverse_photos.first.img_file and photo.img_file %}
									<div class="carousel-item">
								{% endif %}
						      <img class="d-block img-fluid" src="assets/images/{{ photo.img_file }}" data-holder-rendered="true">
						    </div>
							{% endif %}
						{% endfor %}

				  </div>

				  <a class="carousel-control-prev" href="#photo-carousel" role="button" data-slide="prev">
				    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
				    <span class="sr-only">Previous</span>
				  </a>
				  <a class="carousel-control-next" href="#photo-carousel" role="button" data-slide="next">
				    <span class="carousel-control-next-icon" aria-hidden="true"></span>
				    <span class="sr-only">Next</span>
				  </a>
				</div>

			</div>

		</div>


		<div class="row">
			<div class="col-md-8">
				<div class="news-feed">
					<h2>Latest News</h2>

					<p>Here is some new news</p>
				</div>
			</div>

			<div class="col-md-4" style="margin:0; padding:0;">
				<iframe src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2FAmericanPolypaySheepAssociation%2F&tabs=timeline&width=380&height=600&small_header=false&adapt_container_width=true&hide_cover=false&show_facepile=true&appId" width="380" height="600" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowTransparency="true"></iframe>
			</div>



		</div>
	</div>
</div>
