Food.delete_all

Food.create!(
  name: "Tenderloin Steak",
  description: 
    %{<p>
      <em>Daging Terbaik dari Setiap Sapi</em>
      Tenderloin hanya terdapat di bagian tengah sapi. 
      Kami menyajikan Tenderloin dari 3 negara asal: United States, New Zealand dan Indonesia.
      Kami mengerti tenderloin merupakan daging tanpa lemak yang sangat empuk,
      dan disukai banyak orang karena mudah mengunyahnya.
      Sudah coba Tenderloin steak racikan kami?
      </p>},
  image_url: "Tenderloin.png",
  price: 95000.00
)

Food.create!(
  name: "Sirloin Steak",
  description: 
    %{<p>
      <em>Best Seller</em>
      Sirloin adalah daging bagian atas dari sapi yang ada jalur lemaknya di sisi atas.
      Sirloin steak memiliki kelebihan tersendiri yang beda dari bagian daging sapi lainnya,
      lemak yang ada disisi atas memberikan aroma yang harum ketika dipanggang.
      </p>},
  image_url: "Sirloin.png",
  price: 85000.00
)

Food.create!(
  name: "Rib Eye Steak",
  description: 
    %{<p>
      <em>Paling Populer dan Paling Juicy</em>
      Rib Eye adalah bagian daging sapi yang berasal dari daging di sekitar tulang iga atau tulang rusuk.
      Rib Eye termasuk dari delapan bagian utama daging sapi yang biasa dikonsumsi.
      Rib Eye steak adalah potongan dalam bentuk steak, bisa dengan tulang atau tanpa tulang.
      Bagian ini memiliki aroma dan rasa yang lezat karena lemak yang masih menempel.
      </p>},
  image_url: "Rib Eye.png",
  price: 90000.00
)