export type EquipmentId = 'cameras' | 'audio';

export type EquipmentGuide = {
  label: string;
  url: string;
  format: 'PDF' | 'Support page' | 'Online guide';
};

export type EquipmentManual = {
  id: EquipmentId;
  title: string;
  model: string;
  summary: string;
  status: string;
  facts: string[];
  guides: EquipmentGuide[];
  productUrl: string;
};

/** Public equipment selections and manufacturer guides; no private device access. */
export const equipmentManuals: EquipmentManual[] = [
  {
    id: 'cameras',
    title: 'My exterior cameras',
    model: 'eufy PoE NVR Security System S4 Max',
    summary: 'I will feature my selected eufy S4 Max kit with four PoE Cam S4 bullet-PTZ cameras and a Network Video Recorder S4 with a 2 TB hard drive.',
    status: 'I have identified my selected equipment; my camera placement, wiring and configuration still need confirmation.',
    facts: [
      'Each of my selected Bullet-PTZ cameras combines a fixed 4K view with a movable zoom view.',
      'My selected system supports coordinated tracking between compatible cameras.',
      'My PoE cameras use Ethernet for power and data.',
      'My recorder and camera quick-start guides contain English within multilingual PDFs. My system user guide opens on eufy’s support page.'
    ],
    guides: [
      {
        label: 'System user guide',
        url: 'https://service.eufy.com/article-description/NVR-Security-System-User-Guide-E8P10?urlName=NVR-Security-System-User-Guide-E8P10',
        format: 'Support page'
      },
      {
        label: 'Network Video Recorder S4 quick-start guide — includes English',
        url: 'https://lp.ankerjapan.com/hubfs/aoos/manual/T8N00QSG.pdf',
        format: 'PDF'
      },
      {
        label: 'PoE Cam S4 quick-start guide — includes English',
        url: 'https://lp.ankerjapan.com/hubfs/aoos/manual/T8E00QSG.pdf',
        format: 'PDF'
      }
    ],
    productUrl: 'https://www.eufy.com/products/e8e00121'
  },
  {
    id: 'audio',
    title: 'My audio receiver',
    model: 'Sony STR-AN1000',
    summary: 'I will feature my selected Sony AN1000 multi-channel AV receiver. Sony’s US product information identifies the full model as STR-AN1000.',
    status: 'I have identified my receiver; my connected speakers, wiring and calibration still need confirmation.',
    facts: [
      'My receiver supports 7.2-channel audio and Dolby Atmos and DTS:X decoding with compatible sources and speakers.',
      'My receiver’s capabilities do not establish my connected speaker layout or confirm completed setup.',
      'My English Help Guide covers the STR-AN1000 and TA-AN1000; my Operating Instructions identify the US STR-AN1000 and include English.'
    ],
    guides: [
      {
        label: 'English Help Guide',
        url: 'https://helpguide.sony.net/ha/strtaan10/v1/en/index.html',
        format: 'Online guide'
      },
      {
        label: 'Printable English Help Guide',
        url: 'https://helpguide.sony.net/ha/strtaan10/v1/en/print.pdf',
        format: 'PDF'
      },
      {
        label: 'Operating Instructions — includes English',
        url: 'https://www.sony.com/electronics/support/res/manuals/5037/b33415fde106bb6d2fc890a4347b078d/50370281M.pdf',
        format: 'PDF'
      }
    ],
    productUrl: 'https://electronics.sony.com/audio/audio-components/av-receivers/p/stran1000'
  }
];
