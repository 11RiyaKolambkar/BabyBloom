import mongoose from 'mongoose';
import dotenv from 'dotenv';
import { Product } from './models/productModel.js';

dotenv.config();

const products = [
    // 1. Baby Care
    {
        p_name: "Gentle Nourishing Baby Lotion (200ml)",
        desc: "Hypoallergenic and dermatologically tested gentle moisturising baby lotion with organic shea butter and chamomile.",
        price: 349,
        stock: 50,
        img: ["/uploads/1748066878231.jpg"],
        category: "Baby Care"
    },
    {
        p_name: "Organic Tear-Free Baby Shampoo (300ml)",
        desc: "Mild tear-free daily formula enriched with natural aloe vera and wheat protein to keep baby's hair soft and silky.",
        price: 299,
        stock: 45,
        img: ["/uploads/1748066978790.jpg"],
        category: "Baby Care"
    },
    {
        p_name: "Soothing Diaper Rash Cream (100g)",
        desc: "Zinc oxide enriched soothing barrier cream that protects and heals sensitive baby skin from diaper rashes and irritation.",
        price: 249,
        stock: 60,
        img: ["/uploads/1748067097532.jpg"],
        category: "Baby Care"
    },
    {
        p_name: "Natural Aloe Vera Baby Wipes (Pack of 3)",
        desc: "99% pure water wipes with organic aloe vera and Vitamin E. 100% biodegradable and alcohol-free.",
        price: 399,
        stock: 100,
        img: ["/uploads/1748067285954.jpg"],
        category: "Baby Care"
    },
    {
        p_name: "Ergonomic Anti-Slip Baby Bath Tub",
        desc: "Safe and comfortable baby bathing tub with built-in temperature sensor and soft cushioned backrest.",
        price: 1299,
        stock: 20,
        img: ["/uploads/1748067424627.jpg"],
        category: "Baby Care"
    },
    {
        p_name: "Complete 6-in-1 Baby Grooming Kit",
        desc: "Includes safety nail clippers, round-tip scissors, soft hair brush, nasal aspirator, and comb.",
        price: 499,
        stock: 35,
        img: ["/uploads/1748067684230.jpg"],
        category: "Baby Care"
    },

    // 2. Toys & Learning
    {
        p_name: "Plush Musical Cuddle Teddy Bear",
        desc: "Ultra-soft plush teddy bear with gentle lullaby music and glowing night light to soothe babies to sleep.",
        price: 599,
        stock: 30,
        img: ["/uploads/1748067835310.jpg"],
        category: "Toys & Learning"
    },
    {
        p_name: "Educational Wooden Stacking Rings",
        desc: "Non-toxic wooden stacking rings in vibrant rainbow colors to foster hand-eye coordination and color recognition.",
        price: 449,
        stock: 40,
        img: ["/uploads/1748067952449.jpg"],
        category: "Toys & Learning"
    },
    {
        p_name: "Sensory Soft Building Blocks Set (10 Pcs)",
        desc: "Squeezable, chewable, and BPA-free embossed sensory blocks with numbers and textured patterns.",
        price: 649,
        stock: 25,
        img: ["/uploads/1748068190865.jpg"],
        category: "Toys & Learning"
    },
    {
        p_name: "Baby Activity Kick & Play Piano Gym",
        desc: "Interactive play mat with overhead arch toys, piano keys, musical melodies, and soft playmat.",
        price: 1899,
        stock: 15,
        img: ["/uploads/1748068872075.jpg"],
        category: "Toys & Learning"
    },
    {
        p_name: "Silicone Fruit Teether & Rattle Combo",
        desc: "Food-grade silicone soothing teether toy with easy grip design to relieve sore gums during teething.",
        price: 299,
        stock: 70,
        img: ["/uploads/1748069446637.jpg"],
        category: "Toys & Learning"
    },
    {
        p_name: "Wooden Shape Sorter Activity Cube",
        desc: "5-in-1 multifunctional developmental activity cube with bead maze, shape sorting, clock, and spinning gears.",
        price: 899,
        stock: 20,
        img: ["/uploads/1748069598276.jpg"],
        category: "Toys & Learning"
    },

    // 3. Boys Fashion
    {
        p_name: "Newborn 100% Cotton Romper Set (Pack of 3)",
        desc: "Soft, breathable pure cotton full-sleeve snap rompers with cute prints for daily comfort and easy diaper changes.",
        price: 799,
        stock: 40,
        img: ["/uploads/1748189794059.jpg"],
        category: "Boys Fashion"
    },
    {
        p_name: "Baby Boy Denim Dungaree & Striped Tee",
        desc: "Stylish denim dungaree with adjustable shoulder straps paired with a comfortable 100% cotton crewneck tee.",
        price: 999,
        stock: 25,
        img: ["/uploads/1748190054546.jpg"],
        category: "Boys Fashion"
    },
    {
        p_name: "Cute Dinosaur Print Zip-Up Sleepsuit",
        desc: "Cozy two-way zipper footed onesie with safety chin guard and adorable embroidered dinosaur graphics.",
        price: 549,
        stock: 35,
        img: ["/uploads/1748190153354.jpg"],
        category: "Boys Fashion"
    },
    {
        p_name: "Infant Boys Hooded Winter Jacket",
        desc: "Warm, lightweight windproof jacket with soft fleece lining, front zipper, and cute bear ears on the hood.",
        price: 1199,
        stock: 18,
        img: ["/uploads/1748190532242.jpg"],
        category: "Boys Fashion"
    },
    {
        p_name: "Casual Polo Shirt & Chino Shorts Outfit",
        desc: "Smart-casual outfit with breathable cotton polo shirt and elastic waistband chino shorts.",
        price: 849,
        stock: 30,
        img: ["/uploads/1748273792345.jpg"],
        category: "Boys Fashion"
    },

    // 4. Girls Fashion
    {
        p_name: "Pastel Floral Princess Party Frock",
        desc: "Beautiful flared tulle frock with floral embroidery, soft cotton inner lining, and elegant satin waist bow.",
        price: 1099,
        stock: 25,
        img: ["/uploads/1748958914583.webp"],
        category: "Girls Fashion"
    },
    {
        p_name: "Cotton Ruffle Romper with Matching Headband",
        desc: "Adorable sleeveless ruffle-trim cotton romper with snap closure and an elasticated floral bow headband.",
        price: 699,
        stock: 40,
        img: ["/uploads/1748959521439.webp"],
        category: "Girls Fashion"
    },
    {
        p_name: "Pink Knitted Button-Up Baby Cardigan",
        desc: "Super-soft acrylic-cotton blend knitted sweater with wooden buttons, designed to keep baby girls warm.",
        price: 749,
        stock: 30,
        img: ["/uploads/1748959801410.webp"],
        category: "Girls Fashion"
    },
    {
        p_name: "Sweet Cherry Print Summer Dress Set",
        desc: "Breathable lightweight A-line summer dress with playful cherry prints and matching bloomers.",
        price: 599,
        stock: 35,
        img: ["/uploads/1748960046648.webp"],
        category: "Girls Fashion"
    },
    {
        p_name: "Velvet Winter Frock with Long Sleeves",
        desc: "Premium soft plush velvet long-sleeve dress with Peter Pan collar and delicate lace detailing.",
        price: 1299,
        stock: 15,
        img: ["/uploads/1748960191383.webp"],
        category: "Girls Fashion"
    },

    // 5. Feeding & Nursing
    {
        p_name: "Anti-Colic Glass Feeding Bottle (240ml)",
        desc: "BPA-free borosilicate glass feeding bottle with slow-flow silicone teat and anti-colic air vent valve.",
        price: 599,
        stock: 50,
        img: ["/uploads/1748960459145.webp"],
        category: "Feeding & Nursing"
    },
    {
        p_name: "Waterproof Silicone Baby Bibs (Set of 2)",
        desc: "Food-grade waterproof silicone bibs with wide crumb catcher pocket and adjustable neck snaps.",
        price: 399,
        stock: 65,
        img: ["/uploads/1748960754817.webp"],
        category: "Feeding & Nursing"
    },
    {
        p_name: "Fast Electric Baby Bottle Warmer & Sterilizer",
        desc: "Multifunctional double bottle warmer with fast steam heating, constant temperature holding, and defrost.",
        price: 1599,
        stock: 20,
        img: ["/uploads/1748961086940.webp"],
        category: "Feeding & Nursing"
    },
    {
        p_name: "Weighted Straw Spill-Proof Sippy Cup (200ml)",
        desc: "360-degree weighted straw sippy cup allowing babies to drink comfortably from any angle without spills.",
        price: 349,
        stock: 45,
        img: ["/uploads/1748961338807.webp"],
        category: "Feeding & Nursing"
    },

    // 6. Diapering & Hygiene
    {
        p_name: "Ultra-Soft Cotton Newborn Diapers (48 Pcs)",
        desc: "Breathable 12-hour leak-lock absorption diapers with wetness indicator for newborn comfort and dry skin.",
        price: 699,
        stock: 80,
        img: ["/uploads/1748067559378.jpg"],
        category: "Diapering & Hygiene"
    },
    {
        p_name: "Portable Felt Diaper Caddy Organizer",
        desc: "Spacious multi-compartment nursery storage tote bag for diapers, wipes, bottles, and changing essentials.",
        price: 799,
        stock: 30,
        img: ["/uploads/1748961558151.webp"],
        category: "Diapering & Hygiene"
    },
    {
        p_name: "Waterproof Foldable Baby Changing Mat",
        desc: "Cushioned wipe-clean portable changing pad with headrest pillow, ideal for home and on-the-go travel.",
        price: 499,
        stock: 40,
        img: ["/uploads/1748961890145.webp"],
        category: "Diapering & Hygiene"
    },

    // 7. Bedding & Nursery
    {
        p_name: "Organic Cotton Muslin Baby Swaddle Blanket (Pack of 2)",
        desc: "Breathable, lightweight 100% organic cotton muslin swaddles that get softer with every wash.",
        price: 649,
        stock: 45,
        img: ["/uploads/1749059939386.webp"],
        category: "Bedding & Nursery"
    },
    {
        p_name: "Baby Bed with Mosquito Net & Pillow Set",
        desc: "Foldable portable sleeping mattress with attached breathable zipper mosquito net and shaped infant pillow.",
        price: 899,
        stock: 25,
        img: ["/uploads/1749060037530.webp"],
        category: "Bedding & Nursery"
    },
    {
        p_name: "Plush Fleece Baby Sleeping Bag / Wrap",
        desc: "Ultra-cozy hooded swaddle wrap with velcro wings to keep newborn snug, warm, and secure.",
        price: 699,
        stock: 35,
        img: ["/uploads/1749060154914.webp"],
        category: "Bedding & Nursery"
    },

    // 8. Baby Gear & Travel
    {
        p_name: "Lightweight Compact Foldable Baby Stroller",
        desc: "One-hand fold travel stroller with multi-position reclining seat, large canopy, and smooth suspension wheels.",
        price: 4499,
        stock: 12,
        img: ["/uploads/1749060368797.webp"],
        category: "Baby Gear & Travel"
    },
    {
        p_name: "Ergonomic 3-in-1 Baby Wrap & Carrier",
        desc: "Breathable mesh baby front carrier with lumbar support and adjustable padded shoulder straps.",
        price: 1799,
        stock: 22,
        img: ["/uploads/1749060546212.webp"],
        category: "Baby Gear & Travel"
    },
    {
        p_name: "Infant-to-Toddler Rocker & Bouncer Chair",
        desc: "Calming vibrations bouncer with removable toy bar, secure 3-point harness, and foldable kickstand.",
        price: 2499,
        stock: 15,
        img: ["/uploads/1749060773795.webp"],
        category: "Baby Gear & Travel"
    }
];

async function seed() {
    try {
        await mongoose.connect(process.env.mongoSecret || "mongodb://localhost:27017/babyBloom");
        console.log("Connected to MongoDB");
        
        await Product.deleteMany({});
        console.log("Cleared existing products");
        
        const inserted = await Product.insertMany(products);
        console.log(`Successfully seeded ${inserted.length} products across multiple categories!`);
        
        await mongoose.disconnect();
    } catch (err) {
        console.error("Seeding error:", err);
        process.exit(1);
    }
}

seed();
