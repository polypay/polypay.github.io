---
layout: default
title: Photo Gallery
category: photo_gallery
permalink: /photo_gallery/
width: 3
columns: 4
---

<div class="photo-gallery">

<h2>{{ page.title }}</h2>

<p>Polypay sheep are versatile and able to thrive in a variety of environments under different production systems. Check out the pictures below and click on each image to see a larger version with more information about the sheep in the picture. If you would like to contribute a picture, please use our <a href="https://docs.google.com/forms/d/e/1FAIpQLSdhDrJNmEt9RxaIkx1H1b1WTN8l251GXtFfZK7ldSMUxXIxdA/viewform?usp=sf_link" target="_blank">submission form</a>.
</p>

<!-- http://ashleydw.github.io/lightbox/#image-gallery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.3.0/ekko-lightbox.min.js"></script>


{% assign column_index = 0 %}
{% assign reverse_photos = site.photo_gallery | reverse %}

	<div class="container">
		<div class="justify-content-center">

			{% for photo in reverse_photos %}
				{% if photo.img_file %}
					{% if column_index == 0 %}<div class="row">{% endif %}
					{% assign column_index = column_index | plus: 1 %}

					<div class="col-md-{{page.width}}">

			      <a href="/assets/images/{{ photo.img_file }}" data-toggle="lightbox" data-gallery="photo-gallery" class="col-sm-3" data-title="{{ photo.title }}" data-footer="Submitted by {{ photo.contributor}} on {{ photo.date_submitted | date: "%B %e, %Y" }}">
			          <img src="/assets/images/{{ photo.img_file }}" class="img-fluid">
			      </a>

					</div>
				{% endif %}

				{% if column_index == page.columns  %}
					{% assign column_index = 0 %}
					</div>
				{% endif %}
			{% endfor %}

			{% if column_index != 0 %}
				</div>
			{% endif %}

		</div>
	</div>
</div>

<script>
$(document).on('click', '[data-toggle="lightbox"]', function(event) {
                event.preventDefault();
                $(this).ekkoLightbox();
            });
</script>
