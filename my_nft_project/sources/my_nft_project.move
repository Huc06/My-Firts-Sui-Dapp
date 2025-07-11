module my_nft_project::my_nft_collection {
    use sui::object::{UID, new, id as object_id, id_to_address};
    use sui::tx_context::{TxContext, sender, epoch_timestamp_ms};
    use sui::event::emit;
    use sui::transfer;
    use sui::table::{Table, add, remove, length, new as new_table};
    use std::string::String;

    /// NFT rút gọn với 4 trường cơ bản
    public struct MemoryNFT has key, store {
        id: UID,
        name: String,
        description: String,
        image_url: String,
        rarity: u8,
    }

    /// Mẫu dữ liệu để tạo NFT
    ///  Thêm drop để tránh lỗi unconsumed
    public struct MemoryTemplate has store, drop {
        name: String,
        description: String,
        image_url: String,
        rarity: u8,
    }

    /// Object lưu trữ danh sách mẫu NFT
    public struct MemoryTemplateStore has key, store {
        id: UID,
        templates: Table<u64, MemoryTemplate>,
        next_template_id: u64,
    }

    /// Event khi tạo NFT
    public struct MemoryNFTCreated has copy, drop {
        nft_id: address,
        creator: address,
        name: String,
        rarity: u8,
    }

    /// Mint NFT từ template ngẫu nhiên
    public entry fun mint_random_memory_nft(
        store: &mut MemoryTemplateStore,
        ctx: &mut TxContext
    ) {
        let sender_addr = sender(ctx);
        let num_templates = length(&store.templates);
        assert!(num_templates > 0, 1001);

        let seed = epoch_timestamp_ms(ctx);
        let idx = seed % num_templates;
        let last_index = store.next_template_id - 1;

        let selected_template = remove(&mut store.templates, idx);

        if (idx != last_index) {
            let last_template = remove(&mut store.templates, last_index);
            add(&mut store.templates, idx, last_template);
        };
        store.next_template_id = last_index;

        let nft = MemoryNFT {
            id: new(ctx),
            name: selected_template.name,
            description: selected_template.description,
            image_url: selected_template.image_url,
            rarity: selected_template.rarity,
        };

        emit(MemoryNFTCreated {
            nft_id: id_to_address(&object_id(&nft)),
            creator: sender_addr,
            name: nft.name,
            rarity: nft.rarity,
        });

        transfer::transfer(nft, sender_addr);
    }

    /// Thêm template mới
    public entry fun add_memory_template(
        store: &mut MemoryTemplateStore,
        name: String,
        description: String,
        image_url: String,
        rarity: u8,
        _ctx: &mut TxContext
    ) {
        let new_template_id = store.next_template_id;
        store.next_template_id = store.next_template_id + 1;
        add(&mut store.templates, new_template_id, MemoryTemplate {
            name,
            description,
            image_url,
            rarity,
        });
    }
    fun init(ctx: &mut TxContext) {
        transfer::share_object(MemoryTemplateStore {
            id: new(ctx),
            templates: new_table(ctx),
            next_template_id: 0,
        });
    }
}